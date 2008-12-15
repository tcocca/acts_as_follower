require File.dirname(__FILE__) + '/test_helper'

class ActsAsFollowerTest < Test::Unit::TestCase
  fixtures :users, :follows, :bands
  
  def test_instance_methods_should_be_defined
    assert users(:sam).respond_to?(:following?)
    assert users(:sam).respond_to?(:follow_count)
    assert users(:sam).respond_to?(:follow)
    assert users(:sam).respond_to?(:stop_following)
    assert users(:sam).respond_to?(:follows_by_type)
    assert users(:sam).respond_to?(:all_follows)
  end
  
  def test_following_should_returns_following_status
    assert_equal true, users(:sam).following?(users(:jon))
    assert_equal false, users(:jon).following?(users(:sam))
  end
  
  def test_follow_count_should_return_count_of_followed_users
    assert_equal 2, users(:sam).follow_count
    assert_equal 0, users(:jon).follow_count
  end
  
  def test_follow_should_create_relevant_follow_record
    assert_difference "Follow.count", 1 do
      assert_difference "users(:jon).follow_count", 1 do
        users(:jon).follow(users(:sam))
      end    
    end
    assert_equal users(:jon), Follow.last.follower
    assert_equal users(:sam), Follow.last.followable
  end
  
  def test_stop_following_should_create_relevant_follow_record
    assert_difference "Follow.count", -1 do
      assert_difference "users(:sam).follow_count", -1 do
        users(:sam).stop_following(users(:jon))
      end    
    end
  end
  
  def test_follows_by_type_should_return_only_requested_follows
    assert_equal [follows(:band)], users(:sam).follows_by_type('Band')
    assert_equal [follows(:user)], users(:sam).follows_by_type('User')
  end
  
  def test_all_follows_should_return_all_follows
    follows = users(:sam).all_follows
    assert_equal 2, follows.size
    assert follows.include?(follows(:band))
    assert follows.include?(follows(:user))
    assert_equal [], users(:jon).all_follows
  end
  
  def test_all_following_should_return_actual_followed_records    
    following = users(:sam).all_following
    assert_equal 2, following.size
    assert following.include?(bands(:oasis))
    assert following.include?(users(:jon))
    assert_equal [], users(:jon).all_following
  end
  
  def test_following_by_type_should_return_only_requested_records
    assert_equal [bands(:oasis)], users(:sam).following_by_type('Band')
    assert_equal [users(:jon)], users(:sam).following_by_type('User')
  end
  
  def test_method_missing_should_call_following_by_type
    assert_equal [bands(:oasis)], users(:sam).following_bands
    assert_equal [users(:jon)], users(:sam).following_users
  end
  
  def test_method_missing_should_raise
    assert_raises (NoMethodError){ users(:sam).foobar }
  end
  
  def test_destroyed_follower_should_nullifys_related_follows_records
    assert_difference "Follow.count && users(:sam).following_users.size", -1 do
      users(:jon).destroy
    end
  end
  
end
