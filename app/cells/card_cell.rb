class CardCell < HelpfulCell

  def show(options)
    @user = options[:user]
    @image_attachments = Attachment.where(parent_model: "card", parent_id: @model.id, child_model: "image")
    if @user.card.cards.include? @model.id
      @cards = @model.cards.collect { |card_id| Card.find(card_id) }
      render "list"
    else
      render "card"
    end
  end

  def top
    @user = controller.instance_variable_get("@user")
    render
  end

  def list
    @user = controller.instance_variable_get("@user")
    render
  end

  def card
    @user = controller.instance_variable_get("@user")
    render
  end

  def header(options)
    case options[:action]
    when :index
      unless options[:sanitize]
        "#{link_to params[User.slug], user_path(params[User.slug])}'s workboard"
      else
        "#{params[User.slug]}'s workboard"
      end
    end
  end

  def instructions(action)
    case action
    when :index
      @content = "Your workboard is modeled after a #{link_to "kanban board", "https://en.wikipedia.org/wiki/Kanban_board"} and is intended to let you and your commissioners track your work progress. The workboard has three modes. <p>View mode shows you what other users see when they view your workboard. You can use it to check that it gets presented the way you want it to.<p>Edit mode allows you to create new lists and cards and to modify and delete the ones you currently have. Each list has a customizable title, and each card has a customizable title, description, and any number of attachments like commission images.<p>Reorder mode allows you to move cards and lists around. You can change the order of the lists and of the cards within the lists. You can also move cards from one list onto another. Be sure to save your changes with the button in the lower left when you're done."
    end
    render
  end

end