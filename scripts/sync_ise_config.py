
# -*- coding: utf-8 -*-

"""
Script to synchronize files and directories from the current repository to a target GitLab repository.

Purpose:
    - Copies specified files and directories (e.g., ./global) to a remote GitLab repo.
    - Commits and pushes changes automatically.
    - The commit message can be set via the TRIGGER_COMMIT_MESSAGE environment variable (e.g., from CI/CD pipeline).

Usage:
    - Can be run manually or as part of a GitLab CI/CD pipeline.
    - Requires write access and a valid GitLab personal access token in the repo URL.
    - Example: python3 sync_ise_config.py
"""

import os
import shutil
import subprocess
import tempfile

commit_message_env = os.getenv("TRIGGER_COMMIT_MESSAGE")
gitlab_token = os.getenv("TARGET_GITLAB_TOKEN")
gitlab_url = os.getenv("TARGET_GITLAB_REPO_URL")

if not gitlab_token or not gitlab_url:
    raise EnvironmentError("TARGET_GITLAB_TOKEN and TARGET_GITLAB_REPO_URL environment variables must be set.")

repo_url = f"https://oauth2:{gitlab_token}@{gitlab_url}"

REPOS = [
    {
        "url": repo_url,
        "commit_message": "inbound "+commit_message_env if commit_message_env else "sync global configurations to ISE Cluster-4",
        "directories": [
            {
                "src": "./global",
                "dst": "./global",
            },
        ],
    },
]


def print_message(message):
    print(
        "--------------------------------------------------------------------------------"
    )
    print(message)
    print(
        "--------------------------------------------------------------------------------"
    )


def update_repo(repo):
    with tempfile.TemporaryDirectory() as dirname:
        url = repo["url"]
        args = ["git", "clone", url, dirname]
        print_message("git clone")
        subprocess.run(args, check=True)
        # copy files and dirs
        for dir in repo.get("directories", []):
            shutil.copytree(
                dir["src"], os.path.join(dirname, dir["dst"]), dirs_exist_ok=True
            )
        for file in repo.get("files", []):
            shutil.copyfile(file["src"], os.path.join(dirname, file["dst"]))
        cwd = dirname
        args = ["git", "add", "--all"]
        print_message(args)
        subprocess.run(args, cwd=cwd, check=True)
        args = ["git", "diff", "--cached", "--exit-code"]
        print_message(args)
        r = subprocess.run(args, cwd=cwd)
        if r.returncode > 0:
            subprocess.run(
                ["git", "config", "user.email", "your-email@example.com"],
                cwd=cwd,
                check=True,
            )
            subprocess.run(
                ["git", "config", "user.name", "your-gitlab-sync-process"], cwd=cwd, check=True
            )
            args = ["git", "commit", "-m", repo["commit_message"]]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)
            args = ["git", "push"]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)


def update_repos():
    for repo in REPOS:
        print("\n-> Updating repo {}\n".format(repo["url"]))
        update_repo(repo)


if __name__ == "__main__":
    update_repos()