CONFIG = {
  thumbnail_width: 150,
  thumbnail_height: 150,
  email_required: true,
  host: "bleatr.com",
  name: "Bleatr",
  copyright: "&copy;2015",
  image_path: Rails.root.join("app", "assets", "images"),
  image_adult: "not_found.png",
  image_adult_thumb: "not_found.png",
  image_disabled: "not_found.png",
  image_disabled_thumb: "not_found.png",
  image_not_found: "not_found.png",
  image_not_found_thumb: "thumb_not_found.png",
  logo: "logo.png",
  logo_thumb: "thumb_logo.png",
  logo_email: "email_logo.gif",
  banner: "banner.png",
  image_shelf_life: 5.hours,
  password_reset_shelf_life: 2.hours,

  commission_icons: {
    commissions: "perm_identity",
    trades: "repeat",
    requests: "loyalty",
    collaborations: "supervisor_account"
  },

  activity_icons: {
    inactive: "not_interested",
    accepting: "play_circle_outline",
    accepting_few: "error_outline",
    backlogged: "toll",
    open_soon: "schedule",
    on_vacation: "pause_circle_outline"
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