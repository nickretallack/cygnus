module ViewHelper

  def timestamp(item, type = :created)
    case type
    when :created
      item.created_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")
    when :modified
      item.modified_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")
    end
  end

  def readable(stringish)
    unless stringish.is_a? Symbol or stringish.is_a? String
      ""
    else
      stringish.to_s.underscore.humanize
    end
  end

  def format_flash(message, key)
    suffix = ""
    case key.to_sym
    when :success
      suffix = "!"
    when :danger, :info
      suffix = "."
    end
    message.slice(0, 1).capitalize+message.slice(1..-1)+suffix
  end

  def render_markdown(content)
    return "" unless content
    content = content.gsub(/\[(.+?)\]\((.+?)\)/){ |match| external_link("#{$1}", "#{$2}") }
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end

  def enum_for(collection, word: nil, reverse: false, index: false)
    if collection.length < 1
      if word.nil?
        concat "<span id = 'nothing'>Nothing here.</span>".html_safe
      else
        concat "<span id = 'nothing'>No #{word}.</span>".html_safe
      end
    end
    unless reverse
      if index
        collection.each_with_index do |item, index|
          yield item, index
        end
      else
        collection.each do |item|
          yield item
        end
      end
    else
      if index
        collection.each_with_index do |item, index|
          yield item, index
        end
      else
        collection.reverse.each do |item|
          yield item
        end
      end
    end
  end

  def summary_for(label, field)
    if field.is_a? Array
      if field.length < 1
        "No #{label} specified."
      else
        "#{readable label}: #{field.join(", ")}"
      end
    else
      if field.blank?
        "No #{label} specified."
      else
        "#{readable label}: #{field}"
      end
    end
  end

  def title_for(instance, name: nil)
    case true
    when !(instance.respond_to? :title rescue false)
      "Untitled"
    when instance.title.blank?
      "Untitled #{name || readable(instance.class.name).titleize}"
    else
      instance.title
    end
  end

  def select_options_for(type)
    case type
    when :artist_type
      [["Artist Type", -1]].
      concat(CONFIG[:artist_types].
      each_with_index.map { |type, index|
        [type, index]
      })
    when :status
      CONFIG[:activity_icons].keys.
      each_with_index.map { |status, index|
        [status.to_s.gsub("_", " "), index]
      }
    end
  end

  def hidable(title = nil, open = false, associated: nil, on_destroy: nil, &block)
    cell(:view).(:hidable, title: title, content: capture(&block), open: open, associated: associated, on_destroy: on_destroy)
  end

  def message(type, recipient = nil, **args)
    cell(:activity, recipient).(:new, type, args)
  end

  def page_nav(position)
    if (position == :top and (setting(:pagination_at_top) or setting(:pagination_at_both))) or (position == :bottom and (not setting(:pagination_at_top) or setting(:pagination_at_both)))
      cell(:view).(:page_nav)
    else
      nil
    end
  end

end