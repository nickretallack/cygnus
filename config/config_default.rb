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

  about_text: "<p />
We were getting tired of how difficult it was to find commissioners who did the type of art we wanted in the genre and style we wanted at the prices we wanted. There's no way to even know all of the artists out there much less pick the one who's perfect to do your picture or story without heavy searching through all the different sites.
<p />
Or, from an artist's point of view, how lame is it that you have to post a journal on every single one of your accounts individually every time you open for commissions? Then when you take an order from someone, you have to update all that stuff manually. Annoying. So here's a catalogue to make all those processes... you know... <b>not</b> take up ridiculous portions of your day.
<p />
Bleatr intends to be the place for artists and commissioners to interact. You'll be able to search through artists who share your interests, view their open statuses and prices, order prints of their work, confer with them, and pay for commissions all from the same site--instead of using some silly combination of... say... FA, GMail, Skype, and Paypal. And maybe eventually we'll be some sort of central hub for the whole furry community!
<p />
Though we offer a gallery feature just to make things convenient, we don't want to work against giants like FurAffinity, InkBunny, Weasyl, SoFurry, or others. Rather, we're a place to consolidate your information and your process. We want you to be able to efficiently do whatever you're in the market to do. Link to us from your profile page elsewhere--where you already have your gallery uploaded--and conduct your business through us. Or upload your stuff with us and operate completely out of one place; we don't mind ^_^
<p />
If you're still reading, you must be pretty interested. So let me spell out a few of our goals:
<ul>
 <li>A form builder that allows artists to make their own invoices, among other things,
 <li>Customizable profile pages (for other people viewing your profile) and site views (for you viewing the site) with a <b>reasonable</b> widget-based interface,
 <li>Sitewide and personal IM style chats as well as PMs,
 <li>Tumblr, Booru, and comic-book style interfaces that you can switch between yourself depending on the purpose you're browsing the site or even automatically based on time of day,
 <li>Auction, poll, donation, and notification functionalities
</ul>
<p />
If you'd like to help us along financially, send an email to TwilightStormshi@gmail.com, and one of us will respond with details on the fairly unheardof things we're doing to fund the site. = ) Cheers!"
}