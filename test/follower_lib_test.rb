require File.dirname(__FILE__) + '/test_helper'

class RockBand < Band; end
class HardRockBand < RockBand; end

class LibTestCase
  include ActsAsFollower::FollowerLib
end

class FollowerLibTest < ActiveSupport::TestCase

  context "parent_class_name" do

    setup do
      @obj = LibTestCase.new
    end

    context "Object inheriting from active record base" do
      should "return the object's class name" do
        assert_equal @obj.send(:parent_class_name, Band.new), Band.name
      end
    end

    context "Single level STI class" do
      should "return the parent classes name" do
        assert_equal @obj.send(:parent_class_name, RockBand.new), Band.name
      end
    end

    context "n Level STI Class" do
      should "return the top level parent from STI" do
        assert_equal @obj.send(:parent_class_name, HardRockBand.new), Band.name
      end
    end
  end
end
