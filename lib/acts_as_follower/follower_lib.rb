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
    
  end
end
