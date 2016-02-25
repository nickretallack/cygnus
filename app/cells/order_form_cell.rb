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
    define_method key do |object = nil|
      @object = object
      @name = key
      @content = render(key)
      render "template"
    end
  end

  def workspace
    html = ""
    @order_form.content.each do |object|
      key, value = object.first
      html << cell(:order_form).(key.underscore, value)
    end
    html
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
      @title = "Build and/or edit an order form"
      @content = "Click a button in the \u201CAdd\u201D area. The matching question template appears in the workspace box below. Fill in the \u201CQuestion\u201D field with the question you want your commissioner to answer.<p>For the \u201Cshort response\u201D and \u201Cfree answer\u201D templates, the bordered \u201Cresponse area\u201D reminds you of the length of the text response your commissioner can give to your question. Within the \u201Cresponse area\u201D for the \u201Cchoose one\u201D and \u201Cchoose all that apply\u201D templates, you can add, remove, edit, and reorder choices for your commissioner to pick from in response to that question.<p>To remove a question, click on the <i class='material-icons'>clear</i> in the upper right of the template.<p>To reorder questions, grab the <i class='material-icons'>drag_handle</i> in the upper left of the template and drag it to its new position.<p>To make a question require an answer, before your commissioner can submit the order, click its numbered title. The title turns red to show you it is required.<p>When you are done, click the save icon in the lower left of your screen. Your form will be saved in the database. You can now copy the shareable link given at the bottom of the page and send it to anyone as described in the previous page's instructions. Whenever you edit your order form and save the changes, the fillable form at that link automatically changes. The link does not become invalid until you delete the form and always links to the newest version."
    end
    render if can_modify? @user
  end

end