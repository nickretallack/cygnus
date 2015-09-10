module ApplicationHelper
  
  ###routing###

  def back
    if request.referer
      redirect_to :back
    else
      redirect_to :root
    end
  end

    #not_found
    #
    #shunts bad urls to a safe location
    #gotchas:
    #
    # must be called in a separate procedure like a before_filter or with (and return) to avoid calling redirect twice in the same action
    #
    #example:
    #
    # def index
    #   @user = User.find(params[User.slug])
    #   not_found and return unless @user
    #   @pool = @user.pools
    # end
    #
  def not_found
    flash[:danger] = "record not found"
    back
  end

    #back_with_errors
    #
    #redirects to referer or root if there are form errors and displays those errors along with the flashes
    #example:
    #
    # if @new_user.save
    #   back
    # else
    #   back_with_errors
  def back_with_errors
    flash[:errors] = instance_variable_get("@new_"+controller_name.singularize).errors.full_messages
    back
  end

  ###formatting###

    #format_flash
    #
    #formats flash messages in a standard way.
    #gotchas:
    #
    # notice: "message" will appear as an :info flash without formatting
    # only the first letter is capitalized; other letters are left with unmodified case
    #
    #example:
    #
    # flash[:success] = "record destroyed"
    # => <div class = "success">Record destroyed!</div>
    #
    #
  def format_flash(message, key)
    suffix = ""
    case key.to_sym
    when :success
      suffix = "!"
    when :danger, :info
      suffix = "."
    end
    ("<span>"+message.slice(0, 1).capitalize+message.slice(1..-1)+suffix+"</span>").html_safe
  end

    #sanitize_title
    #
    #allows tags and apostrophes in :header without bad formatting in the title bar
    #
    #
  def sanitize_title(content)
    sanitize(content, tags: []).gsub("&#39;", "'").titleize
  end

  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end

    #enum_for
    #
    #loops over an enumerable, performing (block) on each item. if the enumerable is empty, a descriptive string is shown in the view and the block is not performed
    #params:
    #
    # collection means the enumerable to loop over
    # word is optional and means a description of the collection for the empty message
    #
    #example:
    #
    # <% enum_for @users do |user| %>
    #   <%= render "links", user: user %>
    # <% end %>
    #
    #
  def enum_for(collection, word = nil)
    if collection.empty?
      if word.nil?
        concat "Nothing here."
      else
        concat "No #{word} yet."
      end
    else
      collection.each do |item|
        yield item
      end
    end
  end

    #message_for, title_for
    #
    #similar to enum_for but for a string database column
    #example:
    #
    # <%= message_for prices: user.price %>
    # => user.price or "No prices specified."
    #
    # <%= title_for submission: @submission %>
    # => @submission.title or "Untitled Submission"
    #
    #
  def message_for(*args)
    key, value = args.first.first
    key = key.to_s.gsub("_", " ").pluralize
    if value.blank?
      "No #{key} specified."
    else
      value
    end
  end

  def title_for(*args)
    key, value = args.first.first
    if value.title.blank?
      "Untitled #{key.to_s.gsub("_", " ").titleize}"
    else
      value.title
    end
  end
end
