require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowableTest < Test::Unit::TestCase
  
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
    
    context "blocking a follower" do
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
        assert_equal 0, @jon.followers_count
      end
      
      should "not be present when listing followers" do
        assert_equal [], @jon.followers
      end
      
      should "be in the list of blocks" do
        assert_equal [@sam], @jon.blocks
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
    
  end
  
end
