class UserCell < HelpfulCell

  def footer(options)
    render "footer/#{options[:action]}" rescue nil
  end

  def status(type)
    render "status/#{type}"
  end

  ["navigation", "show", "edit", "index", "enum", "summary", "attributes", "links", "watch", "request_reset", "reset"].each do |method|
    define_method method do
      render method
    end
  end

  ["show_profile", "edit_profile", "edit_dashboard"].each do |method|
    define_method method do
      render "#{method.split("_")[1]}/#{method.split("_")[0]}"
    end
  end

  ["nav", "menu"].each do |method|
    define_method method do
      render "#{anon?? "anon" : "member"}/#{method}"
    end
  end

end