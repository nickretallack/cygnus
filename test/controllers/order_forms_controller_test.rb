require 'test_helper'

class OrderFormsControllerTest < ActionController::TestCase
  setup do
    @order_form = order_forms(:orderone)
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
      post :create, order_form: { content: 
			"[\r\n  {\r\n    \"id\": 0,\r\n    \"title\": \"Text\",\r\n    \"type\": \"text\",\r\n    \"contents\": \"\"\r\n  }\r\n]"	  }
    end

    assert_redirected_to order_form_path(assigns(:order_form))
  end

  test "should show order_form" do
    get :show, id: @order_form
    assert_response :success
  end

  test "should get edit" do
    assert_raises(ActionController::RoutingError) do
		assert_recogizes({}, get(:edit, id: @order_form))
	end
    
  end


  test "should destroy order_form" do
    assert_difference('OrderForm.count', -1) do
      delete :destroy, id: @order_form
    end

    assert_redirected_to order_forms_path
  end
end
