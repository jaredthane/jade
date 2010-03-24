require File.dirname(__FILE__) + '/../test_helper'

class UnitsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:units)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_unit
    assert_difference('Unit.count') do
      post :create, :unit => { }
    end

    assert_redirected_to unit_path(assigns(:unit))
  end

  def test_should_show_unit
    get :show, :id => units(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => units(:one).id
    assert_response :success
  end

  def test_should_update_unit
    put :update, :id => units(:one).id, :unit => { }
    assert_redirected_to unit_path(assigns(:unit))
  end

  def test_should_destroy_unit
    assert_difference('Unit.count', -1) do
      delete :destroy, :id => units(:one).id
    end

    assert_redirected_to units_path
  end
end
