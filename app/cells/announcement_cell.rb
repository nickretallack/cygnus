class AnnouncementCell < HelpfulCell

  ["new", "index", "show", "edit"].each do |method|
    define_method method do
      render method
    end
  end

end