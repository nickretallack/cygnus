class CardCell < HelpfulCell

  ["index"].each do |method|
    define_method method do
      render method
    end
  end

  ["top", "list", "new_list", "card", "new_card", "undecided_order", "order"].each do |method|
    define_method method do
      render ->(method){
        method = method.split("_")
        if method[0] == "new"
          "new/#{method[1..-1].join("_")}"
        else
          "show/#{method.join("_")}"
        end
      }.call(method)
    end
  end

  def show
    render((@model.list == @user.card)? "show/list" : "show/card")
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