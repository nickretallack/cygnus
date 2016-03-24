class OrderFormCell < HelpfulCell

  ["index", "head", "enum", "summary", "new", "show"].each do |method|
    define_method method do
      render method
    end
  end

  CONFIG[:order_form_icons].each do |name, icon|
    define_method name do |object = nil|
      if object.nil?
        @question = ""
        @options = [""]
      else
        @question, @options = object.first
      end
      @name = name
      render "template"
    end
  end

  def workspace
    html = ""
    @order_form.content.each do |object|
      name, object = object.first
      html << cell(:order_form).(name.underscore, object)
    end
    html
  end

  def instructions(options)
    case options[:action]
    when :index
      @title = "Order forms"
      @content = "Order forms are an easy way to get information from your commissioner about the work they want done. Each order form is a page you custom build to contain a series of questions you want to present to your commissioner--like giving them an application to fill out. For example, a character-sheet order form could ask for the sex, species, and colors of the commissioner's character, plus some personality details or backstory. After they are done and submit their order, the order will appear on your workboard for you to accept or deny, and the notification counter for new orders in the navigation bar will increase.<br /><br />You do not have to ask for contact information when you build your order form. When filling out your form, the commissioner will automatically be asked to enter their name and email so you know who placed the order with you. Alternately, they can sign into #{CONFIG[:name]} directly from the form or sign up if they don't already have an account; then their account name and email will appear on the order.<br /><br />Once you have built the form, you may click \u201CCopy link\u201D on the same row as the form on this page. (This is not the same link as appears in the address bar when you build the form.) Send this link to a commissioner, and they will be given the blank form to fill out. They can also share the same link with friends who might be interested in getting a commission from you; then their friends can order from you in the same way. The link never expires unless you delete the form from this page.<br /><br />Additionally, if you tell #{CONFIG[:name]} you are open for commissions and you have at least one order form, this will enable a link on both your profile page and your listing on the main page. When anyone clicks this link, they will be given the fillable version of your <b>default</b> order form. (You can turn this feature off in your settings.) Though this \u201CPlace Order\u201D link appears enabled to you as well if you have fulfilled the conditions--to remind you whether or not you are accepting orders--you will not be allowed to place orders with yourself.<br /><br />Start by clicking the add button floating in the lower right of your screen to make a new order form. The order form is now created in the database and appears at the end of the list. Click its name, and you will be taken to a page where you can set/change its name and build the form.  In the same way, you can also edit the contents of a form you've already built and saved. To destroy the form, click the trash icon. When destroying your default order form, the next form on the list automatically becomes the default."
    when :show
      @title = "Build and/or edit an order form"
      @content = "Click a button in the \u201CAdd\u201D area. The matching question template appears in the workspace box below. Fill in the \u201CQuestion\u201D field with the question you want your commissioner to answer.<br /><br />For the \u201Cshort response\u201D and \u201Cfree answer\u201D templates, the bordered \u201Cresponse area\u201D indicates you of the length of the text response your commissioner can give to your question. Within the \u201Cresponse area\u201D for the \u201Cchoose one\u201D and \u201Cchoose all that apply\u201D templates, you can add, remove, edit, and reorder choices for your commissioner to pick from in response to that question. For the two \u201Crequest references\u201D templates, the area below the question reminds you of the type of references you're asking for, links to outside sources or images uploaded directly to the order.<br /><br />To remove a question or choice, click on the <i class='material-icons'>#{CONFIG[:other_icons][:remove]}</i>.<br /><br />To reorder questions or choices, grab the <i class='material-icons'>#{CONFIG[:other_icons][:handle]}</i> and drag it to its new position.<br /><br />When you are done, click the save icon in the lower right of your screen. Your changes will be saved in the database. You can now grab the shareable link and send it to anyone, as described in the previous page's instructions. Whenever you edit your order form and save the changes, the fillable form at that link automatically updates. The link does not become invalid until you delete the form and always links to the newest version."
    end
    render if can_modify? @user and @title
  end

end