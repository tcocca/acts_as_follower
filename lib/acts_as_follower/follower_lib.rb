module ActsAsFollower
  module FollowerLib

    private

    # Retrieves the parent class name if using STI.
    def parent_class_name(obj)
      klass = obj.class
      while klass.superclass != ActiveRecord::Base
        klass = klass.superclass
      end
      return klass.name
    end

  end
end
