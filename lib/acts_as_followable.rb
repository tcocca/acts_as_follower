require File.dirname(__FILE__) + '/follower_lib'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Followable
      
      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include FollowerLib
        end
      end
      
      module ClassMethods
        def acts_as_followable
          has_many :followings, :as => :followable, :dependent => :destroy, :class_name => 'Follow'
          include ActiveRecord::Acts::Followable::InstanceMethods
        end
      end

      
      module InstanceMethods
        
        # Returns the number of followers a record has.
        def followers_count
          self.followings.count
        end
        
        # Returns the following records.
        def followers
          Follow.find(:all, :include => [:follower], :conditions => ["followable_id = ? AND followable_type = ?", 
              self.id, parent_class_name(self)]).collect {|f| f.follower }
        end
        
        # Returns true if the current instance is followed by the passed record.
        def followed_by?(follower)
          Follow.find(:first, :conditions => ["followable_id = ? AND followable_type = ? AND follower_id = ? AND follower_type = ?", self.id, parent_class_name(self), follower.id, parent_class_name(follower)]) ? true : false
        end
        
      end
      
    end
  end
end
