module LookupHelper

  def children(model)
    matches = []
    attachments.each do |attachment|
      if Regexp.new(model).match(attachment)
        matches << [attachment.split("-")[0], attachment.split("-")[1]]
      end
    end
    matches.collect { |attachment| attachment[0].classify.constantize.find_by(id: attachment[1]) }
  end

  def parents(model)
    model.classify.constantize.where("? = ANY (attachments)", "#{model_name.name.underscore}-#{id}")
  end

end