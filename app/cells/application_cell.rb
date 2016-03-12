class ApplicationCell < HelpfulCell

  ["about"].each do |method|
    define_method method do
      render method
    end
  end

  def header(options)
    case options[:action]
    when :about
      "About #{CONFIG[:name]}"
    end
  end

end