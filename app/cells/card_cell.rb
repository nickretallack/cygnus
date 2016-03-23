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

  def instructions(options)
    case options[:action]
    when :index
      @content = "Your workboard is modeled after a #{link_to "kanban board", "https://en.wikipedia.org/wiki/Kanban_board"} and is intended to let you and your commissioners track your work progress. The workboard has three modes. <br /><br />View mode shows you what other users see when they view your workboard. You can use it to check that it gets presented the way you want it to.<br /><br />Edit mode allows you to create new lists and items on those lists--and to modify and delete the ones you currently have. Each list has a customizable title, and each item has a customizable title and description, and can have an image attached to it. Note: A list or item is created in the database as soon as you click on the respective \u201CAdd\u201D button. The \u201CSave\u201D button on each card only needs to get pressed after you change the title, description, or image.<br /><br />Reorder mode allows you to move cards and lists around. You can change the order of the lists and of the cards within the lists. You can also move cards from one list onto another. You can save the updated ordering with the \u201CFinalize Order\u201D button in the lower left of the reorder section. Note: You can continue using all the other functions of the workboard <em class = 'danger'>except for saving an item with a new image attatched</em> without the unsaved order reverting; just make sure to finalize the order before you leave the workboard page entirely, refresh the page, or upload a new image attachment."
    end
    render if can_modify? @user
  end

end