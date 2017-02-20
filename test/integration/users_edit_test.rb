require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :tranxuannam
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), params: { user: {name: "", email: "invalid@email",
      password: "abc", password_confirmation: "123"}}
    assert_template "users/edit"
    assert_select "#error_explaination div.alert.alert-danger", "4 errors."
  end

  test "successful edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), params: { user: {name: "Xuan Nam Tran",
      email: "tranxuannam@framgia.com.vn", password: "",
      password_confirmation: ""}}
    assert flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, "Xuan Nam Tran"
    assert_equal @user.email, "tranxuannam@framgia.com.vn"
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
  end
end
