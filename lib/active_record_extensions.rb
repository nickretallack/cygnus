module ActiveRecordExtensions
  extend ActiveSupport::Concern

  class_methods do
    def custom_slug(slug)
      self.redefine_method :to_param do
        self.send(slug).parameterize
      end
      self.instance_variable_set "@slug", slug
    end

    def slug
      self.instance_variable_get("@slug") || :id
    end

    def find(record, raise_error: false)
      thing = find_by(slug => record)
      raise ActiveRecord::RecordNotFound if thing.nil? and raise_error
      thing
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecordExtensions