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

  artist_types: [
    "visual/digital",
    "visual/paper",
    "visual/canvas",
    "visual/photography",
    "visual/pixel",
    "visual/comix",
    "visual/animation/tweened",
    "visual/animation/traditional",
    "visual/coloration",
    "visual/decensoring",
    "visual/editing",
    "visual/cg",
    "visual/typesetting",
    "visual/specify type",
    "writing/prose",
    "writing/poetry",
    "writing/lyric",
    "writing/script",
    "writing/translation/specify language",
    "writing/specify type",
    "craft/costume/fursuit",
    "craft/costume/cosplay",
    "craft/costume/specify type",
    "craft/armor/specify type",
    "craft/plush/traditional",
    "craft/plush/adult",
    "craft/body pillow",
    "craft/specify type",
    "coding/websites/php",
    "coding/websites/ruby",
    "coding/websites/javascript",
    "coding/websites/specify language",
    "coding/scripts/specify language",
    "coding/games/flash",
    "coding/games/unity",
    "coding/games/javascript",
    "coding/games/specify type",
    "music/chiptune",
    "music/sampled",
    "music/remix",
    "music/traditional",
    "music/specify type"
  ]
}