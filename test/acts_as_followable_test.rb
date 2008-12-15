require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowableTest < Test::Unit::TestCase
  fixtures :users, :follows
  
  def test_instance_methods_should_be_defined
    assert users(:sam).respond_to?(:followers_count)
    assert users(:sam).respond_to?(:followers)
    assert users(:sam).respond_to?(:followed_by?)
  end
  
  def test_followers_should_return_number_of_followers
    assert_equal 0, users(:sam).followers_count
    assert_equal 1, users(:jon).followers_count
  end
  
  def test_followers_should_return_users
    assert_equal [], users(:sam).followers
    assert_equal [users(:sam)], users(:jon).followers
  end
  
  def test_followed_by_should_return_follower_status
    assert_equal true, users(:jon).followed_by?(users(:sam))
    assert_equal false, users(:sam).followed_by?(users(:jon))
  end
  
  def test_destroyed_followable_should_destroy_related_follows_records
    assert_difference "Follow.count && users(:sam).all_following.size", -1 do
      users(:jon).destroy
    end
  end
  
end
