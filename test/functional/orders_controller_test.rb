require File.dirname(__FILE__) + '/../test_helper'

class OrdersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_order
    assert_difference('Order.count') do
      post :create, :order => { }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  def test_should_show_order
    get :show, :id => orders(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => orders(:one).id
    assert_response :success
  end

  def test_should_update_order
    put :update, :id => orders(:one).id, :order => { }
    assert_redirected_to order_path(assigns(:order))
  end

  def test_should_destroy_order
    assert_difference('Order.count', -1) do
      delete :destroy, :id => orders(:one).id
    end

    assert_redirected_to orders_path
  end
end
