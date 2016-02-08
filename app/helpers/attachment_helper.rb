module AttachmentHelper

  def attachments_for(**args)
    terms = { parent_model: args.keys[0].to_s, parent_id: args.values[0], child_model: args.keys[1].to_s, child_id: args.values[1] }
    result = Attachment.where(terms.to_a[0..2].to_h.reject { |key, value| value == "?" })
    result = result.where("? = ANY(child_ids)", terms[:child_id]) if terms[:child_id] != "?"
    result
  end

  def parents(**args)
    args.keys[0].to_s.classify.constantize.where("id = ANY (?)", "{" + attachments_for(args).map { |attachment| attachment.parent_id }.join(",") + "}")
  end

  

end