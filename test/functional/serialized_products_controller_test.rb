require File.dirname(__FILE__) + '/../test_helper'

class SerializedProductsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:serialized_products)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_serialized_product
    assert_difference('SerializedProduct.count') do
      post :create, :serialized_product => { }
    end

    assert_redirected_to serialized_product_path(assigns(:serialized_product))
  end

  def test_should_show_serialized_product
    get :show, :id => serialized_products(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => serialized_products(:one).id
    assert_response :success
  end

  def test_should_update_serialized_product
    put :update, :id => serialized_products(:one).id, :serialized_product => { }
    assert_redirected_to serialized_product_path(assigns(:serialized_product))
  end

  def test_should_destroy_serialized_product
    assert_difference('SerializedProduct.count', -1) do
      delete :destroy, :id => serialized_products(:one).id
    end

    assert_redirected_to serialized_products_path
  end
end
