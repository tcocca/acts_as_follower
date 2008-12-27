module ActiveRecord #:nodoc:
  module Acts #:nodoc:
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
                 self.id, parent_class_name(self), followable.id, parent_class_name(followable)
               ])
        end
        
        # Returns the number of objects this instance is following.
        def follow_count
          Follow.count(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, parent_class_name(self)])
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
        
        # TODO: Remove from public API.
        # Returns the follow records related to this instance by type.
        def follows_by_type(followable_type)
          Follow.find(:all, :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, parent_class_name(self), followable_type])
        end
        
        # TODO: Remove from public API.
        # Returns the follow records related to this instance by type.
        def all_follows
          Follow.find(:all, :include => [:followable], :conditions => ["follower_id = ? AND follower_type = ?", self.id, parent_class_name(self)])
        end
        
        # Returns the actual records which this instance is following.
        def all_following
          all_follows.map { |f| f.followable }
        end
        
        # Returns the actual records of a particular type which this record is following.
        def following_by_type(followable_type)
          #klass = eval(followable_type) # be careful with this.
          #klass.find(:all, :joins => :follows, :conditions => ['follower_id = ? AND follower_type = ?', self.id, parent_class_name(self)])
          follows_by_type(followable_type).map { |f| f.followable }
        end
        
        # Allows magic names on following_by_type
        # e.g. following_users == following_by_type('User')
        def method_missing(m, *args)
          if m.to_s[/following_(.+)/]
            #following_by_type(parent_class_name($1).classify)
            following_by_type($1.singularize.classify)
          else
            super
          end
        end
        
        private
        
        # Returns a follow record for the current instance and followable object.
        def get_follow(followable)
          Follow.find(:first, :conditions => ["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, parent_class_name(self), followable.id, parent_class_name(followable)])
        end

        # Retrieves the parent class name if using STI.
        def parent_class_name(obj)
          if obj.class.superclass != ActiveRecord::Base
            return obj.class.superclass.name
          end

          return obj.class.name
        end

      end
      
    end
  end
end
