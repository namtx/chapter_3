require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Tran Xuan Nam", email: "tran.xuan.nam@framgia.com",
      password: "123456", password_confirmation: "123456")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should be not too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should be not too long" do
    @user.email = "a"*244 + "@framgia.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExamPLE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password shoud be present (nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create! content: "Lorem ipsum"
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "feed should have the right posts" do
    nam = users :tranxuannam
    admin = users :admin
    maria = users :maria

    nam.microposts.each do |post_following|
      assert admin.feed.include? post_following
    end

    admin.microposts.each do |post_self|
      assert admin.feed.include? post_following
    end

    maria.microposts.each do |post_unfollowed|
      assert_not admin.feed.include? post_following
    end
  end
end
