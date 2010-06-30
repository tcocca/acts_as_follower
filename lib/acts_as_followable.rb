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
          self.followings.unblocked.count
        end

        def blocked_followers_count
          self.followings.blocked.count
        end

        # Returns the following records.
        def followers(options={})
          options = {
            :include => [:follower]
          }.merge(options)
          self.followings.unblocked.all(options).collect{|f| f.follower}
        end

        def blocks(options={})
          options = {
            :include => [:follower]
          }.merge(options)
          self.followings.blocked.all(options).collect{|f| f.follower}
        end

        # Returns true if the current instance is followed by the passed record
        # Returns false if the current instance is blocked by the passed record or no follow is found
        def followed_by?(follower)
          f = get_follow_for(follower)
          (f && !f.blocked?) ? true : false
        end

        def block(follower)
          get_follow_for(follower) ? block_existing_follow(follower) : block_future_follow(follower)
        end

        def unblock(follower)
          get_follow_for(follower).try(:delete)
        end

        private

        def get_follow_for(follower)
          Follow.find(:first, :conditions => ["followable_id = ? AND followable_type = ? AND follower_id = ? AND follower_type = ?", self.id, parent_class_name(self), follower.id, parent_class_name(follower)])
        end

        def block_future_follow(follower)
          follows.create(:followable => self, :follower => follower, :blocked => true)
        end

        def block_existing_follow(follower)
          get_follow_for(follower).block!
        end

      end

    end
  end
end
