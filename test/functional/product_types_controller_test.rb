require File.dirname(__FILE__) + '/../test_helper'

class ProductTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:product_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_product_type
    assert_difference('ProductType.count') do
      post :create, :product_type => { }
    end

    assert_redirected_to product_type_path(assigns(:product_type))
  end

  def test_should_show_product_type
    get :show, :id => product_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => product_types(:one).id
    assert_response :success
  end

  def test_should_update_product_type
    put :update, :id => product_types(:one).id, :product_type => { }
    assert_redirected_to product_type_path(assigns(:product_type))
  end

  def test_should_destroy_product_type
    assert_difference('ProductType.count', -1) do
      delete :destroy, :id => product_types(:one).id
    end

    assert_redirected_to product_types_path
  end
end
