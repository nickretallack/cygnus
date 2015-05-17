require 'test_helper'

class OrderFormsControllerTest < ActionController::TestCase
  setup do
    @order_form = order_forms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_form" do
    assert_difference('OrderForm.count') do
      post :create, order_form: { data: @order_form.data, user_id: @order_form.user_id }
    end

    assert_redirected_to order_form_path(assigns(:order_form))
  end

  test "should show order_form" do
    get :show, id: @order_form
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_form
    assert_response :success
  end

  test "should update order_form" do
    patch :update, id: @order_form, order_form: { data: @order_form.data, user_id: @order_form.user_id }
    assert_redirected_to order_form_path(assigns(:order_form))
  end

  test "should destroy order_form" do
    assert_difference('OrderForm.count', -1) do
      delete :destroy, id: @order_form
    end

    assert_redirected_to order_forms_path
  end
end
