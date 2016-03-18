class OrderCell < HelpfulCell

  ["new", "show"].each do |method|
    define_method method do
      render method
    end
  end

  def new_order
    html = ""
    @order.content.each_with_index do |object, index|
      @name, content = object.first
      @question, @options = content.first
      @index = index
      @question = "blank" if @question.blank?
      html << render("new/template")
    end
    html
  end

  def show_order
    html = ""
    @order.content.each_with_index do |object, index|
      @name, content = object.first
      @question, @answer = content.first
      @question = "(blank)" if @question.blank?
      @answer = "(no response)" if @answer.blank?
      @answer = ["(no response)"] if @answer == [""]
      @index = index
      html << render("show/template")
    end
    html
  end

  def header(options)
    case options[:action]
    when :new
      unless options[:sanitize]
        "Place an order with #{link_to @order.user.name, user_path(@order.user)}"
      else
        "Order from #{@order.user.name}"
      end
    when :show
      unless options[:sanitize]
        "Order from #{link_to(@order.patron.name, user_path(@order.patron)) rescue @order.name}"
      else
        "Order from #{@order.patron.name}"
      end
    end
  end

  def instructions(options)
    case options[:action]
    when :new
      @title = "Place an order"
      @content = ""
      @content << "You are about to place a commission order. The following is a list of questions the artist has drawn up for you pertaining to the work you want done. When you have answered them to your satisfaction, press the \u201CPlace Order\u201D button in the lower right of your screen."
      @content << "<p><span class = 'danger'>You are currently logged into #{CONFIG[:name]} as #{current_user.name}, and your account email is #{current_user.email}. This information will be included on your order. Alternately, you can log out then register a new account or sign in as a different user from the menu. You will not be redirected away from this page in the process.</span></p>" unless anon?
      @content << "<p>You can #{"also log out and" unless anon?} place your order anonymously, but the artist will not receive any indication of whom the order is from unless you tell them yourself."
      @content << " You can sign up or sign in from the menu in the navigation bar at the top of your screen; then your username and email will be automatically attached to your order." if anon?
      @content << "</p>"
    end
    render if @content
  end

  CONFIG[:order_form_icons].each do |key, value|
    define_method key do |object = nil|
      @object = object
      ["question", "option", "href", "text"].each do |name|
        instance_variable_set("@#{name}".pluralize, ->{
          unless @object
            [{"value" => nil}]
          else
            fields = @object.select { |element| element["name"] == name }
            if fields == []
              [{"value" => nil}]
            else
              fields
            end
          end
        }.call)
      end
      @name = key
      @content = render(key)
      render "template"
    end
  end

end