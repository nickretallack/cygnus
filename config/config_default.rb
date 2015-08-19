CONFIG = {
  thumbnail_width: 150,
  thumbnail_height: 150,
  email_required: false,
  host: "localhost",
  name: "Bleatr",
  copyright: "&copy;2015",
  image_adult: Rails.root.join("app/assets/images/icon.png"),
  image_adult_thumb: Rails.root.join("app/assets/images/icon.png"),
  image_disabled: Rails.root.join("app/assets/images/icon.png"),
  image_disabled_thumb: Rails.root.join("app/assets/images/icon.png"),
  logo: Rails.root.join("app/assets/images/logo.png"),
  image_shelf_life: 5.hours,

  commission_icons: {
    commissions: "perm_identity",
    trades: "repeat",
    requests: "loyalty",
    collabs: "supervisor_account"
  },

  user_levels: [
    "unactivated",
    "blocked",
    "member",
    "privileged",
    "contributor",
    "test_janitor",
    "janitor",
    "mod",
    "admin"
  ],

  about_text: ""
}