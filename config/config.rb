CONFIG = {
  thumbnail_width: 150,
  thumbnail_height: 150,
  email_required: true,
  host: "bleatr.com",
  name: "Bleatr",
  copyright: "&copy;2015 Lunar Gryphon",
  image_path: Rails.root.join("app", "assets", "images"),
  upload_path: Rails.root.join("app", "assets", "images", "uploads"),
  image_adult: "adult.png",
  image_adult_medium: "adult.png",
  image_adult_thumb: "thumb_adult.png",
  image_disabled: "not_found.png",
  image_disabled_medium: "not_found.png",
  image_disabled_thumb: "thumb_not_found.png",
  image_not_found: "not_found.png",
  image_not_found_limited: "not_found.png",
  image_not_found_medium: "not_found.png",
  image_not_found_thumb: "thumb_not_found.png",
  logo: "logo.png",
  logo_thumb_medium: "thumb_logo.png",
  logo_thumb: "thumb_logo.png",
  logo_email: "email_logo.gif",
  banner: "banner.png", 
  image_shelf_life: 5.hours,
  password_reset_shelf_life: 2.hours,

  default_search_terms: {
    "tags" => "",
    "use_statuses" => {
      "commissions" => "1",
      "trades" => "0",
      "requests" => "0",
      "collaborations" => "0"
    },
    "statuses" => {
      "commissions" => "all_open_statuses",
      "trades" => "all_open_statuses",
      "requests" => "all_open_statuses",
      "collaborations" => "all_open_statuses"
    }
  },

  commission_icons: { #do not change the order of entries without updating everyone's records; db sees an array of statuses, for now
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
    saves: "savse",
    delete: "delete",
    history: 'history',
    edit: "edit",
    add: "add_circle",
    default: "low_priority",
    back: "play_arrow",
    remove: "remove_circle",
    send: "send",
    accept: "check_circle",
    reject: "highlight_off",
    attach: "attach_file",
    unhide: "visibility",
    hide: "visibility_off",
    pm: "email",
    preview_pm: "mail_outline",
    comment: "message",
    preview_comment: "chat_bubble_outline",
    search: "search"
  },

  order_form_icons: {
    short_response: "text_format",
    free_answer: "reorder",
    choose_one: "radio_button_checked",
    choose_all_that_apply: "check_box",
    request_links_to_references: "link",
    request_reference_image_uploads: "image"
  },

  other_icons: {
    remove: "clear",
    minimize: "remove",
    handle: "drag_handle",
    maximize: "add",
    success: "check"
  },

  comment_icons: {
    reply: "reply",
    minimize: "remove",
    quote: "format_quote",
    pm_author: "contact_mail"
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
    "lurker",
    "commissioner",
    "visual - digital",
    "visual - paper",
    "visual - canvas",
    "visual - photography",
    "visual - pixel",
    "visual - comix",
    "visual - animation - tweened",
    "visual - animation - traditional",
    "visual - coloration",
    "visual - decensoring",
    "visual - editing",
    "visual - cg",
    "visual - typesetting",
    "visual - other",
    "writing - prose",
    "writing - poetry",
    "writing - lyrics",
    "writing - script",
    "writing - translation - specify languages",
    "writing - other",
    "craft - costumes - fursuits",
    "craft - costumes - cosplay",
    "craft - armor - specify type",
    "craft - plushes - traditional",
    "craft - plushes - adult",
    "craft - body pillows",
    "craft - other",
    "coding - websites - php",
    "coding - websites - ruby",
    "coding - websites - javascript",
    "coding - websites - specify language",
    "coding - programs - specify language",
    "coding - games - flash",
    "coding - games - unity",
    "coding - games - javascript",
    "coding - games - specify type",
    "music - chiptunes",
    "music - sampled",
    "music - remixes",
    "music - traditional",
    "music - other"
  ]
}