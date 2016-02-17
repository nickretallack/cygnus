CONFIG = {
  thumbnail_width: 150,
  thumbnail_height: 150,
  email_required: false,
  host: "bleatr.com",
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
  search_placeholder: "Artists who do...",

  default_search_terms: {
    "tags" => "",
    "use_statuses" => {
      "commissions" => "1"
    },
    "statuses" => {
      "commissions" => "all open statuses"
    }
  },

  commission_icons: { #do not change the order of entries without updating everyone's records; db sees an array of statuses
    commissions: "local_atm",
    trades: "repeat",
    requests: "chat_bubble_outline",
    collaborations: "people_outline"
  },

  activity_icons: {
    open: "play_circle_outline",
    one_day_only: "error_outline",
    long_wait: "schedule",
    make_a_pitch: "info_outline",
    friends_only: "mood",
    closed: "pause_circle_outline",
    not_interested: "highlight_off"
  },

  button_icons: {
    save: "save",
    delete: "delete",
    edit: "edit",
    add: "add_circle"
  },

  status_categories: {
    open: [:open, :one_day_only],
    maybe: [:long_wait, :make_a_pitch, :friends_only],
    closed: [:closed, :not_interested]
  },

  submission_icons: {
    unfaved: "favorite_border",
    faved: "favorite",
    download: "file_download",
    profile: "account_circle",
    pool: "view_comfy"
  },

  user_levels: [
    "unactivated",
    "banned",
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
    "writing/lyrics",
    "writing/script",
    "writing/translation/specify languages",
    "writing/specify type",
    "craft/costumes/fursuits",
    "craft/costumes/cosplay",
    "craft/armor/specify type",
    "craft/plushes/traditional",
    "craft/plushes/adult",
    "craft/body pillows",
    "craft/specify type",
    "coding/websites/php",
    "coding/websites/ruby",
    "coding/websites/javascript",
    "coding/websites/specify language",
    "coding/programs/specify language",
    "coding/games/flash",
    "coding/games/unity",
    "coding/games/javascript",
    "coding/games/specify type",
    "music/chiptunes",
    "music/sampled",
    "music/remixes",
    "music/traditional",
    "music/specify type",
    "other/specify type"
  ]
}