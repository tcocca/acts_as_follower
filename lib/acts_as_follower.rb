require File.dirname(__FILE__) + '/follower_lib'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Follower

      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include FollowerLib
        end
      end

      module ClassMethods
        def acts_as_follower
          has_many :follows, :as => :follower, :dependent => :destroy
          include ActiveRecord::Acts::Follower::InstanceMethods
        end
      end

      module InstanceMethods

        # Returns true if this instance is following the object passed as an argument.
        def following?(followable)
          0 < Follow.unblocked.count(:all, :conditions => [
                "follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?",
                 self.id, parent_class_name(self), followable.id, parent_class_name(followable)
               ])
        end

        # Returns the number of objects this instance is following.
        def follow_count
          Follow.unblocked.count(:all, :conditions => ["follower_id = ? AND follower_type = ?", self.id, parent_class_name(self)])
        end

        # Creates a new follow record for this instance to follow the passed object.
        # Does not allow duplicate records to be created.
        def follow(followable)
          follow = get_follow(followable)
          if follow.blank? && self != followable
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
        def follows_by_type(followable_type, options={})
          options = {
            :include => [:followable],
            :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, parent_class_name(self), followable_type]
          }.merge(options)

          Follow.unblocked.find(:all, options)
        end

        # Returns the follow records related to this instance with the followable included.
        def all_follows(options={})
          options = {
            :include => [:followable]
          }.merge(options)

          self.follows.unblocked.all(options)
        end

        # Returns the actual records which this instance is following.
        def all_following(options={})
          all_follows(options).collect{ |f| f.followable }
        end

        # Returns the actual records of a particular type which this record is following.
        def following_by_type(followable_type, options={})
          follows_by_type(followable_type, options).collect{ |f| f.followable }
        end

        def following_by_type_count(followable_type)
          Follow.unblocked.count(:all, :conditions => ["follower_id = ? AND follower_type = ? AND followable_type = ?", self.id, parent_class_name(self), followable_type])
        end

        # Allows magic names on following_by_type
        # e.g. following_users == following_by_type('User')
        # Allows magic names on following_by_type_count
        # e.g. following_users_count == following_by_type_count('User')
        def method_missing(m, *args)
          if m.to_s[/following_(.+)_count/]
            following_by_type_count($1.singularize.classify)
          elsif m.to_s[/following_(.+)/]
            following_by_type($1.singularize.classify)
          else
            super
          end
        end

        private

        # Returns a follow record for the current instance and followable object.
        def get_follow(followable)
          Follow.unblocked.find(:first, :conditions => ["follower_id = ? AND follower_type = ? AND followable_id = ? AND followable_type = ?", self.id, parent_class_name(self), followable.id, parent_class_name(followable)])
        end

      end

    end
  end
end
