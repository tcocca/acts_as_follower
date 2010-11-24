require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowableTest < ActiveSupport::TestCase

  context "instance methods" do
    setup do
      @sam = Factory(:sam)
    end

    should "be defined" do
      assert @sam.respond_to?(:followers_count)
      assert @sam.respond_to?(:followers)
      assert @sam.respond_to?(:followed_by?)
    end
  end

  context "acts_as_followable" do
    setup do
      @sam = Factory(:sam)
      @jon = Factory(:jon)
      @oasis = Factory(:oasis)
      @metallica = Factory(:metallica)
      @sam.follow(@jon)
    end

    context "followers_count" do
      should "return the number of followers" do
        assert_equal 0, @sam.followers_count
        assert_equal 1, @jon.followers_count
      end

      should "return the proper number of multiple followers" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal 0, @sam.followers_count
        assert_equal 1, @jon.followers_count
        assert_equal 1, @bob.followers_count
      end
    end

    context "followers" do
      should "return users" do
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
      end

      should "return users (multiple followers)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
        assert_equal [@sam], @bob.followers
      end

      should "return users (multiple followers, complex)" do
        @bob = Factory(:bob)
        @sam.follow(@bob)
        @jon.follow(@bob)
        assert_equal [], @sam.followers
        assert_equal [@sam], @jon.followers
        assert_equal [@sam, @jon], @bob.followers
      end

      should "accept AR options" do
        @bob = Factory(:bob)
        @bob.follow(@jon)
        assert_equal 1, @jon.followers(:limit => 1).count
      end
    end

    context "followed_by" do
      should "return_follower_status" do
        assert_equal true, @jon.followed_by?(@sam)
        assert_equal false, @sam.followed_by?(@jon)
      end
    end

    context "destroying a followable" do
      setup do
        @jon.destroy
      end

      should_change("follow count", :by => -1) { Follow.count }
      should_change("@sam.all_following.size", :by => -1) { @sam.all_following.size }
    end

    context "blocks" do
      setup do
        @bob = Factory(:bob)
        @jon.block(@sam)
        @jon.block(@bob)
      end

      should "accept AR options" do
        assert_equal 1, @jon.blocks(:limit => 1).count
      end
    end

    context "blocking a follower" do
      context "in my following list" do
        setup do
          @jon.block(@sam)
        end

        should "remove him from followers" do
          assert_equal 0, @jon.followers_count
        end

        should "add him to the blocked followers" do
          assert_equal 1, @jon.blocked_followers_count
        end

        should "not be able to follow again" do
          @jon.follow(@sam)
          assert_equal 0, @jon.followers_count
        end

        should "not be present when listing followers" do
          assert_equal [], @jon.followers
        end

        should "be in the list of blocks" do
          assert_equal [@sam], @jon.blocks
        end
      end

      context "not in my following list" do
        setup do
          @sam.block(@jon)
        end

        should "add him to the blocked followers" do
          assert_equal 1, @sam.blocked_followers_count
        end

        should "not be able to follow again" do
          @sam.follow(@jon)
          assert_equal 0, @sam.followers_count
        end

        should "not be present when listing followers" do
          assert_equal [], @sam.followers
        end

        should "be in the list of blocks" do
          assert_equal [@jon], @sam.blocks
        end
      end
    end

    context "unblocking a blocked follow" do
      setup do
        @jon.block(@sam)
        @jon.unblock(@sam)
      end

      should "not include the unblocked user in the list of followers" do
        assert_equal [], @jon.followers
      end

      should "remove him from the blocked followers" do
        assert_equal 0, @jon.blocked_followers_count
        assert_equal [], @jon.blocks
      end
    end

    context "unblock a non-existent follow" do
      setup do
        @sam.stop_following(@jon)
        @jon.unblock(@sam)
      end

      should "not be in the list of followers" do
        assert_equal [], @jon.followers
      end

      should "not be in the blockked followers count" do
        assert_equal 0, @jon.blocked_followers_count
      end

      should "not be in the blocks list" do
        assert_equal [], @jon.blocks
      end
    end

    context "followers_by_type" do
      setup do
        @sam.follow(@oasis)
        @jon.follow(@oasis)
      end

      should "return the followers for given type" do
        assert_equal [@sam], @jon.followers_by_type('User')
        assert_equal [@sam,@jon], @oasis.followers_by_type('User')
      end

      should "not return block followers in the followers for a given type" do
        @oasis.block(@jon)
        assert_equal [@sam], @oasis.followers_by_type('User')
      end

      should "return the count for followers_by_type_count for a given type" do
        assert_equal 1, @jon.followers_by_type_count('User')
        assert_equal 2, @oasis.followers_by_type_count('User')
      end

      should "not count blocked follows in the count" do
        @oasis.block(@sam)
        assert_equal 1, @oasis.followers_by_type_count('User')
      end
    end

    context "method_missing" do
      setup do
        @sam.follow(@oasis)
        @jon.follow(@oasis)
      end

      should "return the followers for given type" do
        assert_equal [@sam], @jon.user_followers
        assert_equal [@sam,@jon], @oasis.user_followers
      end

      should "not return block followers in the followers for a given type" do
        @oasis.block(@jon)
        assert_equal [@sam], @oasis.user_followers
      end

      should "return the count for followers_by_type_count for a given type" do
        assert_equal 1, @jon.count_user_followers
        assert_equal 2, @oasis.count_user_followers
      end

      should "not count blocked follows in the count" do
        @oasis.block(@sam)
        assert_equal 1, @oasis.count_user_followers
      end
    end
  end

end
