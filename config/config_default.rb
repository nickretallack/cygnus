CONFIG = {
  thumbnail_width: 150,
  thumbnail_height: 150,
  email_required: true,
  host: "bleatr.cloudapp.net",
  name: "Bleatr",
  copyright: "&copy;2015 Lunar Gryphon",
  image_path: Rails.root.join("app", "assets", "images"),
  image_adult: "adult.png",
  image_adult_thumb: "thumb_adult.png",
  image_disabled: "not_found.png",
  image_disabled_thumb: "thumb_not_found.png",
  image_not_found: "not_found.png",
  image_not_found_thumb: "thumb_not_found.png",
  logo: "logo.png",
  logo_thumb: "thumb_logo.png",
  logo_email: "email_logo.gif",
  banner: "banner.png", 
  image_shelf_life: 5.hours,
  password_reset_shelf_life: 2.hours,

  commission_icons: {
    commissions: "loyalty",
    trades: "repeat",
    requests: "comment",
    collaborations: "supervisor_account"
  },

  activity_icons: {
    inactive: "not_interested",
    accepting: "play_circle_outline",
    accepting_few: "error_outline",
    backlogged: "toll",
    open_soon: "schedule",
    vacation: "pause_circle_outline"
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

  
}