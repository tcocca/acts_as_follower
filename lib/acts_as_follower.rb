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
          extend  ActiveRecord::Acts::Follower::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        def following?(followable)
          0 < Follow.count(:all, :conditions => [
                "follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?",
                 self.id, self.class.name, followable.id, followable.class.name
               ])
        end
        
        def follow_count
          Follow.count(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, self.class.name])
        end
        
        def follow(followable)
          Follow.create(:followable => followable, :follower => self)
        end
        
        def stop_following(followable)
          follow = get_follow(followable)
          if follow
            follow.destroy
          end
        end
        
        def follows_by_type(followable_type)
          Follow.find(:all, :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, self.class.name, followable_type])
        end
        
        def all_follows
          Follow.find(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, self.class.name])
        end
        
        private
        
        def get_follow(followable)
          Follow.find(:first, :conditions => ["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, self.class.name, followable.id, followable.class.name])
        end
        
      end
      
    end
  end
end
