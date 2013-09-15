module ActsAsFollower
  module FollowerLib

    private

    # Retrieves the parent class name if using STI.
    def parent_class_name(obj)
      if obj.class.superclass != ActiveRecord::Base
        return obj.class.superclass.name
      end
      return obj.class.name
    end

    def apply_options_to_scope(scope, options = {})
      if options.has_key?(:limit)
        scope = scope.limit(options[:limit])
      end
      if options.has_key?(:includes)
        scope = scope.includes(options[:includes])
      end
      if options.has_key?(:joins)
        scope = scope.joins(options[:joins])
      end
      if options.has_key?(:where)
        scope = scope.order(options[:where])
      end
      if options.has_key?(:order)
        scope = scope.order(options[:order])
      end
      scope
    end
  end
end
