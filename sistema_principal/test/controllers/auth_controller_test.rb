require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get auth_new_url
    assert_response :success
  end

  test "should get create" do
    get auth_create_url
    assert_response :success
  end

  test "should get login_form" do
    get auth_login_form_url
    assert_response :success
  end

  test "should get login" do
    get auth_login_url
    assert_response :success
  end

  test "should get logout" do
    get auth_logout_url
    assert_response :success
  end
end
