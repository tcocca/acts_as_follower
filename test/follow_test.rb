require File.dirname(__FILE__) + '/test_helper'

class FollowTest < ActiveSupport::TestCase

  # Replace with real tests
  def test_assert_true_should_be_true
    assert true
  end

  context "configuration with setters" do
    should "contain custom parents" do
      ActsAsFollower.custom_parent_classes = [CustomRecord]

      assert_equal [CustomRecord], ActsAsFollower.custom_parent_classes
    end
  end

  context "#setup" do
    should "contain custom parents via setup" do
      ActsAsFollower.setup do |c|
        c.custom_parent_classes = [CustomRecord]
      end

      assert_equal [CustomRecord], ActsAsFollower.custom_parent_classes
    end
  end

  context "with custom parents" do
    setup do
      @daddy = FactoryGirl.create(:daddy)
      @mommy = FactoryGirl.create(:mommy)
      @oasis = FactoryGirl.create(:oasis)
      @metallica = FactoryGirl.create(:metallica)
    end

    should "be followed" do
      ActsAsFollower.custom_parent_classes = [CustomRecord]

      @daddy.follow(@mommy)
      @daddy.follow(@metallica)
      @mommy.follow(@oasis)
      assert_equal true, @daddy.following?(@mommy)
      assert_equal false, @mommy.following?(@daddy)
      assert_equal true, @mommy.followed_by?(@daddy)
      assert_equal false, @daddy.followed_by?(@mommy)
      assert_equal true, @metallica.followed_by?(@daddy)
      assert_equal true, @oasis.followed_by?(@mommy)
      assert_equal true, @daddy.following?(@metallica)
      assert_equal true, @mommy.following?(@oasis)
    end

    should "be not followed" do
      ActsAsFollower.custom_parent_classes = []

      @daddy.follow(@mommy)
      @mommy.follow(@oasis)
      assert_equal false, @daddy.following?(@mommy)
      assert_equal false, @mommy.following?(@oasis)
    end
  end
end
