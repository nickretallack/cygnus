class OrderCell < HelpfulCell

  ["new", "show", "short_summary", "summary", "head", "enum", "index"].each do |method|
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
      @answer = ["(no response)"] if @answer.is_a? Array and @answer.reject{ |answer| answer.blank? }.empty?
      @index = index
      html << render("show/template")
    end
    html
  end

  def instructions(options)
    case options[:action]
    when :new
      @title = "Place an order"
      @content = ""
      @content << "You are about to place a commission order. The following is a list of questions the artist wants to ask you pertaining to the work you want done. When you have answered them to your satisfaction, press the \u201CPlace Order\u201D button in the bottom right of your screen and your order will be submitted directly to #{@order.user.name}."
      @content << "<br /><br /><span class = 'danger'>You are currently signed in as #{current_user.name}, and your account email is #{current_user.email}. This information will be included on your order. Alternately, you can log out then register a new account or sign in as a different user from the menu. You will not be redirected away from this page in the process.</span>" unless anon?
      @content << "<br /><br /><span class = 'danger'>You are not signed in at the moment.</span>" if anon?
      @content << "<br />You can #{"also log out and" unless anon?} place your order without being signed in, but you will need to fill in your name and email in the form below if you want #{@order.user.name} to know who you are."
      @content << " Or you can sign up or sign in from the menu in the navigation bar at the top of your screen; then your username and email will be automatically attached to your order and you will be able to track the orders you have placed on your \u201COrders\u201D page, accessible from the member menu." if anon?
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