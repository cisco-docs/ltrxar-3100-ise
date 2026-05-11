# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

import os
import shutil

import errorhandler
import nac_test.pabot
import pytest
import tftest
from util import render_templates

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.ise

error_handler = errorhandler.ErrorHandler()

ISE_TEST_TEMPLATES_PATH = "templates/ise/test/"


def ise_render_run_tests(ise_url, data_paths, output_path, ise_password=None):
    """Render ISE test suites and run them using iac-test"""
    error = render_templates(data_paths, output_path, ISE_TEST_TEMPLATES_PATH)
    if error:
        pytest.fail(error)
    os.environ["ISE_URL"] = ise_url
    original_password = os.environ.get("ISE_PASSWORD")
    if ise_password is not None:
        os.environ["ISE_PASSWORD"] = ise_password
    try:
        nac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    finally:
        if ise_password is not None:
            if original_password is not None:
                os.environ["ISE_PASSWORD"] = original_password
            else:
                del os.environ["ISE_PASSWORD"]
    return None


def full_ise_terraform_test(data_paths, terraform_path, ise_url, version, tmpdir, ise_password=None):
    """Deploy config to ISE instance using Terraform"""

    os.environ["ISE_URL"] = ise_url
    original_password = os.environ.get("ISE_PASSWORD")
    if ise_password is not None:
        os.environ["ISE_PASSWORD"] = ise_password
    tf = tftest.TerraformTest(terraform_path)

    try:
        tf.setup(cleanup_on_exit=False, upgrade="upgrade")

        tf.apply()

        # check idempotency
        output = tf.apply()
        if "No changes. Your infrastructure matches the configuration." not in output:
            pytest.fail(output)

        # Run tests
        data_paths.append(os.path.join(terraform_path, "defaults.yaml"))
        error = ise_render_run_tests(
            ise_url, data_paths, os.path.join(tmpdir, "results/"), ise_password=ise_password
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "log.html"),
            "ise_tf_{}_log.html".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "report.html"),
            "ise_tf_{}_report.html".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "output.xml"),
            "ise_tf_{}_output.xml".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "xunit.xml"),
            "ise_tf_{}_xunit.xml".format(version),
        )
        if error:
            pytest.fail(error)
    finally:
        if ise_password is not None:
            if original_password is not None:
                os.environ["ISE_PASSWORD"] = original_password
            else:
                del os.environ["ISE_PASSWORD"]
        try:
            tf.destroy()
        except:
            tf.destroy()
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)


@pytest.mark.ise_32
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, ise_url, version",
    [
        (
            [
                "tests/integration/fixtures/ise/standard/",
                "defaults/",
            ],
            "tests/integration/fixtures/ise/terraform_32",
            "https://10.50.202.28",
            "3.2",
        ),
    ],
)
def test_ise_terraform_32(data_paths, terraform_path, ise_url, version, tmpdir):
    full_ise_terraform_test(data_paths, terraform_path, ise_url, version, tmpdir)

@pytest.mark.ise_33
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, ise_url, version",
    [
        (
            [
                "tests/integration/fixtures/ise/standard/",
                "tests/integration/fixtures/ise/standard_33/",
                "defaults/",
            ],
            "tests/integration/fixtures/ise/terraform_33",
            "https://10.50.202.19",
            "3.3",
        ),
    ],
)
def test_ise_terraform_33(data_paths, terraform_path, ise_url, version, tmpdir):
    full_ise_terraform_test(data_paths, terraform_path, ise_url, version, tmpdir)

@pytest.mark.ise_34
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, ise_url, version",
    [
        (
            [
                "tests/integration/fixtures/ise/standard/",
                "tests/integration/fixtures/ise/standard_33/",
                "tests/integration/fixtures/ise/standard_34/",
                "defaults/",
            ],
            "tests/integration/fixtures/ise/terraform_34",
            "https://10.50.202.104",
            "3.4",
        ),
    ],
)
def test_ise_terraform_34(data_paths, terraform_path, ise_url, version, tmpdir):
    full_ise_terraform_test(data_paths, terraform_path, ise_url, version, tmpdir)

@pytest.mark.ise_35
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, ise_url, version",
    [
        (
            [
                "tests/integration/fixtures/ise/standard/",
                "tests/integration/fixtures/ise/standard_33/",
                "tests/integration/fixtures/ise/standard_34/",
                "defaults/",
            ],
            "tests/integration/fixtures/ise/terraform_35",
            "https://10.62.190.197",
            "3.5",
        ),
    ],
)
def test_ise_terraform_35(data_paths, terraform_path, ise_url, version, tmpdir):
    ise_password = os.environ.get("ISE_PASSWORD_35")
    full_ise_terraform_test(data_paths, terraform_path, ise_url, version, tmpdir, ise_password=ise_password)
