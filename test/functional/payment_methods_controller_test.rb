require File.dirname(__FILE__) + '/../test_helper'

class PaymentMethodsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_methods)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_payment_method
    assert_difference('PaymentMethod.count') do
      post :create, :payment_method => { }
    end

    assert_redirected_to payment_method_path(assigns(:payment_method))
  end

  def test_should_show_payment_method
    get :show, :id => payment_methods(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => payment_methods(:one).id
    assert_response :success
  end

  def test_should_update_payment_method
    put :update, :id => payment_methods(:one).id, :payment_method => { }
    assert_redirected_to payment_method_path(assigns(:payment_method))
  end

  def test_should_destroy_payment_method
    assert_difference('PaymentMethod.count', -1) do
      delete :destroy, :id => payment_methods(:one).id
    end

    assert_redirected_to payment_methods_path
  end
end
