module ImageHelper

  #image_for
  #
  #renders an image inline with defaults for hiding inactive, not found, and adult images if necessary
  #params:
  #
  # type: the style of image to render. paths to images are specified in config
  #   :full means the complete image, as uploaded
  #   :thumb means the thumbnail image rendered from the full image
  #   :bordered means the thumbnail image with a border indicating sfw vs nsfw
  #   :logo means the full site logo
  #   :logo_thumb means the thumbnail-size logo
  #   :logo_email means the logo sent in the registration email, gif formatted for transparency compatibility with most email servers
  #   :banner means the full site banner
  #   :any other symbol will search config for that symbol and try displaying the base path given within the images directory
  #  id: the id of the upload object associated with the image
  #
  #example:
  #
  # <% enum_for @submissions do |submission| %>
  #   <%= image_for :bordered, submission.file_id
  # <% end %>
  #
  #
  def image_for(type = :full, id = nil)
    #render template: "images/show", locals: { type: type, id: id }
    cell(:image, Upload.find(id) || Upload.new, type: type)
  end

  #avatar_for
  #
  #renders a user avatar inline, nsfw-safe
  #
  #
  def avatar_for(user, type = :bordered)
    image_for(type, user.avatar)
  end
end