module ActiveRecord
  module Acts
    module Follower
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_follower
          has_many :follows, :as => :follower, :dependent => :nullify  # If a following entity is deleted, keep the follows. 
          include ActiveRecord::Acts::Follower::InstanceMethods
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # Returns true if this instance is following the object passed as an argument.
        def following?(followable)
          0 < Follow.count(:all, :conditions => [
                "follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?",
                 self.id, self.class.name, followable.id, followable.class.name
               ])
        end
        
        # Returns the number of objects this instance is following.
        def follow_count
          Follow.count(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, self.class.name])
        end
        
        # Creates a new follow record for this instance to follow the passed object.
        # Does not allow duplicate records to be created.
        def follow(followable)
          follow = get_follow(followable)
          unless follow
            Follow.create(:followable => followable, :follower => self)
          end
        end
        
        # Deletes the follow record if it exists.
        def stop_following(followable)
          follow = get_follow(followable)
          if follow
            follow.destroy
          end
        end
        
        # Returns the follow records related to this instance by type.
        def follows_by_type(followable_type)
          Follow.find(:all, :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, self.class.name, followable_type])
        end
        
        # Returns the follow records related to this instance by type.
        def all_follows
          Follow.find(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, self.class.name])
        end
        
        private
        
        # Returns a follow record for the current instance and followable object.
        def get_follow(followable)
          Follow.find(:first, :conditions => ["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, self.class.name, followable.id, followable.class.name])
        end
        
      end
      
    end
  end
end
