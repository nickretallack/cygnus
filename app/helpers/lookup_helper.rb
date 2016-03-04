module LookupHelper

  def children(model, alternate_name = nil)
    matches = []
    attachments.each do |attachment|
      if Regexp.new("#{alternate_name || model}-").match(attachment)
        matches << attachment.split("-")[1]
      end
    end
    model.classify.constantize.where("id = ANY (?)", "{#{matches.compact.join(",")}}")
  end

  def parents(model, alternate_name = nil)
    model.classify.constantize.where("? = ANY (attachments)", "#{alternate_name || model_name.name.underscore}-#{id}")
  end

end