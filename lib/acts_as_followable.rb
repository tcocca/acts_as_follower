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

        # Returns the followers by a given type
        def followers_by_type(follower_type, options={})
          ar_options = {
            :include => [:follower],
            :conditions => ["follower_type = ?", follower_type]
          }.merge(options)
          self.followings.unblocked.find(:all, ar_options).collect{|f| f.follower}
        end

        def followers_by_type_count(follower_type)
          self.followings.unblocked.count(:all, :conditions => ["follower_type = ?", follower_type])
        end

        # Allows magic names on followers_by_type
        # e.g. user_followers == followers_by_type('User')
        # Allows magic names on followers_by_type_count
        # e.g. count_user_followers == followers_by_type_count('User')
        def method_missing(m, *args)
          if m.to_s[/count_(.+)_followers/]
            followers_by_type_count($1.singularize.classify)
          elsif m.to_s[/(.+)_followers/]
            followers_by_type($1.singularize.classify)
          else
            super
          end
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
