module ActiveRecordExtensions
  extend ActiveSupport::Concern

  class_methods do
    def each_page_show(number)
      self.instance_variable_set("@results_per_page", number)
    end

    def results_per_page
      self.instance_variable_get("@results_per_page")
    end

    def custom_slug(slug, case_insensitive: false)
      self.redefine_method :to_param do
        self.send(slug)
      end
      self.instance_variable_set "@slug", slug
      self.instance_variable_set "@case_insensitive", case_insensitive
    end

    def slug
      self.instance_variable_get("@slug") || :id
    end

    def case_insensitive_slug
      self.instance_variable_get("@case_insensitive") || false
    end

    def find_slug(record, raise_error: false)
      if case_insensitive_slug
        thing = where("lower(#{slug}) = ?", record.nil?? nil : record.downcase).first
      else
        thing = find_by(slug => record)
      end
      raise ActiveRecord::RecordNotFound if thing.nil? and raise_error
      thing
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecordExtensions
ActiveRecord::Base.send :include, LookupHelper