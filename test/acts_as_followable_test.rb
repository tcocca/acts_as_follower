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
      
      should_change "Follow.count", :by => -1
      should_change "@sam.all_following.size", :by => -1
    end
  end
  
end
