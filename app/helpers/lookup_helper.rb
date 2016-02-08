module LookupHelper

  def new_lookup(**args)
    Lookup.new(parent_model: args.keys[0].to_s, parent_ids: [args.values[0]], child_model: args.keys[1].to_s, child_id: args.values[1]).save!
  end

  def lookups_for(**args)
    terms = { parent_model: args.keys[0].to_s, parent_id: args.values[0], child_model: args.keys[1].to_s, child_id: args.values[1] }.reject { |key, value| value == "?" }
    result = Lookup.where(parent_model: terms[:parent_model], child_model: terms[:child_model])
    result = result.where("? = ANY(parent_ids)", terms[:parent_id]) if terms[:parent_id]
    result = result.where(child_id: terms[:child_id]) if terms[:child_id]
    result
  end

  def parents(**args)
    args.keys[0].to_s.classify.constantize.where("id = ANY (?)", "{" + lookups_for(args).map { |lookup| lookup.parent_ids.join(",") }.join(",") + "}")
  end

  def children(**args)
    args.keys[1].to_s.classify.constantize.where("id = ANY (?)", "{" + lookups_for(args).map { |lookup| lookup.child_id }.join(",") + "}")
  end

end