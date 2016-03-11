module LookupHelper

  def children(model, alternate_name = nil)
    matches = []
    attachments.each do |attachment|
      if Regexp.new("#{alternate_name || model}-").match(attachment)
        matches << attachment.split("-")[1].to_i
      end
    end
#    model.classify.constantize.where("id = ANY (?)", "{#{matches.join(",")}}").sort_by { |item| matches.index item.id }
    matches.delete(0)
    children = model.classify.constantize.where("id = ANY ('{#{matches.join(",")}}')")
    #children = children.order("idx(array[#{matches.join(",")}], id)") unless matches.empty?
    children
  end

  def parents(model, alternate_name = nil)
    model.classify.constantize.where("? = ANY (attachments)", "#{alternate_name || model_name.name.underscore}-#{id}")
  end

end