variable "checkly_api_key" {}
variable "checkly_account_id" {}

# specify the Checkly provider
terraform {
  required_providers {
    checkly = {
      source = "checkly/checkly"
    }
  }
}

# pass the API Key environment variable to the provider
provider "checkly" {
  api_key    = var.checkly_api_key
  account_id = var.checkly_account_id
}

# define an API check
resource "checkly_check" "nas" {
  name                      = "NAS"
  type                      = "API"
  activated                 = true
  should_fail               = false
  frequency                 = 1
  double_check              = true
  use_global_alert_settings = true

  locations = [
    "eu-central-1"
  ]

  request {
    url              = "https://nas.stackmasters.com:5001/"
    follow_redirects = true
    assertion {
      source     = "STATUS_CODE"
      comparison = "EQUALS"
      target     = "200"
    }
  }

  alert_channel_subscription {
    channel_id = "52211"
    activated  = true
  }

  alert_channel_subscription {
    channel_id = "52213"
    activated  = true
  }

}
