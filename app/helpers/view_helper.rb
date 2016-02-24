module ViewHelper

  def readable(stringish)
    unless stringish.is_a? Symbol or stringish.is_a? String
      ""
    else
      stringish.to_s.underscore.humanize
    end
  end

  def format_artist_type(array)
    array.map { |index| CONFIG[:artist_types][index.to_i] }.collect { |type| type.split("/") }.collect { |type|
      ->(word) {
        case word
        when "visual"
          "visual arts: "
        when "craft", "coding", "other"
          ""
        else
          "#{word}: "
        end
      }.call(type[0])+
      ->(type) {
        if type[2]
          case type[1]
          when "costumes"
            "#{type[2]}"
          when "websites"
            "#{type[1]} in #{type[2]}"
          when "translation"
            "#{type[1]}:"
          else
            "#{type[2]} #{type[1]}"
          end
        else
          type[1]
        end
      }.call(type)
    }.join(", ")
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

  def sanitize_title(content)
    sanitize(content, tags: []).gsub("&#39;", "'").titleize
  end

  def render_markdown(content)
    return "" unless content
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end

  def enum_for(collection, word: nil, reverse: false)
    if collection.empty?
      if word.nil?
        concat "<span id = 'nothing'>Nothing here.</span>".html_safe
      else
        concat "<span id = 'nothing'>No #{word} yet.</span>".html_safe
      end
    else
      unless reverse
        collection.each do |item|
          yield item
        end
      else
        collection.reverse.each do |item|
          yield item
        end
      end
    end
  end

  def message_for(*args)
    key, value = args.first.first
    key = key.to_s.gsub("_", " ")
    if value.blank?
      "No #{key} specified."
    else
      value
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

  def hidable(title = nil, open = false, associated = nil, &block)
    cell(:view).(:hidable, title: title, content: capture(&block), open: open, associated: associated)
  end

end