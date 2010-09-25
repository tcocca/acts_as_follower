module ActsAsFollower #:nodoc:
  module Followable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_followable
        has_many :followings, :as => :followable, :dependent => :destroy, :class_name => 'Follow'
        include ActsAsFollower::Followable::InstanceMethods
        include ActsAsFollower::FollowerLib
      end
    end


    module InstanceMethods

      # Returns the number of followers a record has.
      def followers_count
        self.followings.unblocked.count
      end

      # Returns the followers by a given type
      def followers_by_type(follower_type, options={})
        follows = follower_type.constantize.
          includes(:follows).
          where('blocked = ?', false).
          where(
            "follows.followable_id = ? AND follows.followable_type = ? AND follows.follower_type = ?", 
            self.id, parent_class_name(self), follower_type
          )
        if options.has_key?(:limit)
          follows = follows.limit(options[:limit])
        end
        follows
      end

      def followers_by_type_count(follower_type)
        self.followings.unblocked.for_follower_type(follower_type).count
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
        self.followings.unblocked.includes(:follower).all(options).collect{|f| f.follower}
      end

      def blocks(options={})
        self.followings.blocked.includes(:follower).all(options).collect{|f| f.follower}
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
        Follow.for_followable(self).for_follower(follower).first
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
