CONFIG = {}

#true or false ONLY

CONFIG["Email_Required"] = true

#domain, minus http
CONFIG["Host"] = "bleatr.com"

#names of things
CONFIG["Name"] = "Bleatr"


#user levels, unactivated, member and admin in use
CONFIG["user_levels"] = {
  "Unactivated" => 0,
  "Blocked" => 10,
  "Member" => 20,
  "Privileged" => 30,
  "Contributor" => 33,
  "Test Janitor" => 34,
  "Janitor" => 35,
  "Mod" => 40,
  "Admin" => 50
}
CONFIG["Image_Adult"] = "";
CONFIG["Image_Adult_Thumb"] = "";
CONFIG["Image_Disabled"] = "";
CONFIG["Image_Disabled_Thumb"] = "";
