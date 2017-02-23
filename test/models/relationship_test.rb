require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
      @relationship = Relationship.new follower_id: users(:admin).id,
        followed_id: users(:tranxuannam).id
    end

    test "should be valid" do
      assert @relationship.valid?
    end

    test "should require a follower_id" do
      @relationship.follower_id = nil
      assert_not @relationship.valid?
    end

    test "should require a followed_id" do
      @relationship.followed_id = nil
      assert_not @relationship.valid?
    end

    test "should follow and unfollow a user" do
      admin  = users(:admin)
      other   = users(:tranxuannam)
      assert_not admin.following?(other)
      admin.follow(other)
      assert admin.following?(other)
      assert other.followers.include?(admin)
      admin.unfollow(other)
      assert_not admin.following?(other)
    end
end
