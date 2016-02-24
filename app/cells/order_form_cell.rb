class OrderFormCell < HelpfulCell

  def index
    render
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  CONFIG[:order_form_icons].each do |key, value|
    define_method key do
      html = ""
      html << "<div class = 'handle'></div>"
      html << "<div class = 'content'>" << render(key) << "</div>"
      html << "<input type = 'checkbox' name = 'required'></input>"
      html << "<i class = 'material-icons small'>clear</i>"
    end
  end

  def header(options)
    case options[:action]
    when :index
      unless options[:sanitize]
        "#{link_to @user.name, user_path(@user)}'s order forms"
      else
        "#{@user.name}'s order forms"
      end
    when :show
    when :edit
    end
  end

  def instructions(options)
    case options[:action]
    when :index
      @title = "Order forms"
      @content = "Order forms are an easy way to get information from your commissioner about the work they want done. Each order form is a page you custom build to contain a series of questions you want to present to your commissioner--like giving them an application to fill out. A character-sheet order form could ask for the sex, species, and colors of a their character, for example, plus some personality details or backstory.<p>Once you have built the form, you will be given a sharable link. Send the link to a commissioner, and they will be given the blank form to fill out. (Also, if they click the \u201COrder\u201D link under your listing on the main page or your profile page, they will be given a fillable version of your <b>default</b> order form.) After they are done and submit their order, the order will appear on your workboard for you to accept or deny. You can also choose to automatically have a PM and/or email sent to you about the new order.<p>Additionally, the commissioner can sign into #{CONFIG[:name]} directly from the form (or sign up if they don't already have an account) so their account name and email will appear on the order. They can also share the same link with others who might be interested in getting a commission from you; then they can order from you in the same way. The link never expires unless you delete the form from this page.<p>(But remember, if you tell #{CONFIG[:name]} that you are closed for commissions at the time, no one will be allowed to submit orders to you. Order forms are automatically updated with your current statuses.)<p>Click the add button floating in the lower left of your screen to make a new order form. The order form is now created in the database and appears at the end of the list. Click the edit icon next to it, and you will be taken to a page where you can set its name and build the form. You can also edit the contents of a form you've already built. To destroy the form, click the trash icon. When destroying your default order form, the next form on the list automatically becomes the default."
    when :edit
      @title = "Build an order form"
      @content = ""
    end
    render if can_modify? @user
  end

end