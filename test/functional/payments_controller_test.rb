require File.dirname(__FILE__) + '/../test_helper'

class PaymentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_payment
    assert_difference('Payment.count') do
      post :create, :payment => { }
    end

    assert_redirected_to payment_path(assigns(:payment))
  end

  def test_should_show_payment
    get :show, :id => payments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => payments(:one).id
    assert_response :success
  end

  def test_should_update_payment
    put :update, :id => payments(:one).id, :payment => { }
    assert_redirected_to payment_path(assigns(:payment))
  end

  def test_should_destroy_payment
    assert_difference('Payment.count', -1) do
      delete :destroy, :id => payments(:one).id
    end

    assert_redirected_to payments_path
  end
end
