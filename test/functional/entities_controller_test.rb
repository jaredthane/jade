require File.dirname(__FILE__) + '/../test_helper'

class EntitiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:entities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_entity
    assert_difference('Entity.count') do
      post :create, :entity => { }
    end

    assert_redirected_to entity_path(assigns(:entity))
  end

  def test_should_show_entity
    get :show, :id => entities(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => entities(:one).id
    assert_response :success
  end

  def test_should_update_entity
    put :update, :id => entities(:one).id, :entity => { }
    assert_redirected_to entity_path(assigns(:entity))
  end

  def test_should_destroy_entity
    assert_difference('Entity.count', -1) do
      delete :destroy, :id => entities(:one).id
    end

    assert_redirected_to entities_path
  end
end
