module LookupHelper

  def new_lookup(parent_model, parent_id, child_model, child_id)
    Lookup.new(parent_model: parent_model.to_s, parent_ids: [parent_id], child_model: child_model.to_s, child_id: child_id).save!
  end

  def lookups_for(parent_model, parent_id, child_model, child_id)
    terms = { parent_model: parent_model.to_s, parent_id: parent_id, child_model: child_model.to_s, child_id: child_id }.reject { |key, value| value == "?" }
    result = Lookup.where(parent_model: terms[:parent_model], child_model: terms[:child_model])
    result = result.where("? = ANY(parent_ids)", terms[:parent_id]) if terms[:parent_id]
    result = result.where(child_id: terms[:child_id]) if terms[:child_id]
    result
  end

  def lookup_for(parent_model, parent_id, child_model, child_id)
    lookups_for(parent_model, parent_id, child_model, child_id).first || Lookup.new
  end

  def parents(parent_model, parent_id, child_model, child_id)
    parent_model.to_s.classify.constantize.where("id = ANY (?)", "{" + lookups_for(parent_model, parent_id, child_model, child_id).map { |lookup| lookup.parent_ids.join(",") }.join(",") + "}")
  end

  def children(parent_model, parent_id, child_model, child_id)
    child_model.to_s.classify.constantize.where("id = ANY (?)", "{" + lookups_for(parent_model, parent_id, child_model, child_id).map { |lookup| lookup.child_id }.join(",") + "}")
  end

end