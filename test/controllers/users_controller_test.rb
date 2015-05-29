require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
	
    request.env["HTTP_REFERER"] = "/"
  end
  
  test "should get index" do
    get :index
    assert_response :success
	
    assert_not_nil assigns(:users)
  end

  
  test "login with invalid information" do

    post :logon, session: { email: "rete", password: "rter" }
    assert_not flash.empty?
  end
  
  test "should get show" do
    get :show, id: @user.name
    assert_response :success
	assert_select "h1", @user.name
  end

  test "should create user" do
	@newser = { name:  "ExampleUser",
                            email: "user@example.com",
                            password: "password",
                            password_confirmation: "password" }
    assert_difference('User.count') do
      post :create, user: @newser
	end
    assert_redirected_to root_path
  end 
 
  test "should get edit, but 302" do
    get :edit, id: @user.name
    assert_response :redirect
  end
  
  test "should get edit" do
  
    post :logon, session: { email: @user.email, password: 'password' }

    get :edit, id: @user.name
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should update user with valid login" do
    post :logon, session: { email: @user.email, password: 'password' } #logs user in
    patch :update, id: @user.name, user: { name: @user.name }
    assert_redirected_to user_path(@user.name)
  end  
  
  test "should destroy user" do
    post :logon, session: { email: @user.email, password: 'password' }
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.name
    end

    assert_redirected_to users_path
  end

end