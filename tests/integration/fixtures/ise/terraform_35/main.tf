module "ise" {
  source = "github.com/netascode/terraform-ise-nac-ise"

  yaml_directories = ["../standard", "../standard_33", "../standard_34"]
}
