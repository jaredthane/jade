require File.dirname(__FILE__) + '/../test_helper'

class MovementTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movement_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_movement_type
    assert_difference('MovementType.count') do
      post :create, :movement_type => { }
    end

    assert_redirected_to movement_type_path(assigns(:movement_type))
  end

  def test_should_show_movement_type
    get :show, :id => movement_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => movement_types(:one).id
    assert_response :success
  end

  def test_should_update_movement_type
    put :update, :id => movement_types(:one).id, :movement_type => { }
    assert_redirected_to movement_type_path(assigns(:movement_type))
  end

  def test_should_destroy_movement_type
    assert_difference('MovementType.count', -1) do
      delete :destroy, :id => movement_types(:one).id
    end

    assert_redirected_to movement_types_path
  end
end
