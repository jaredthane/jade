require File.dirname(__FILE__) + '/../test_helper'

class EntityTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:entity_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_entity_type
    assert_difference('EntityType.count') do
      post :create, :entity_type => { }
    end

    assert_redirected_to entity_type_path(assigns(:entity_type))
  end

  def test_should_show_entity_type
    get :show, :id => entity_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => entity_types(:one).id
    assert_response :success
  end

  def test_should_update_entity_type
    put :update, :id => entity_types(:one).id, :entity_type => { }
    assert_redirected_to entity_type_path(assigns(:entity_type))
  end

  def test_should_destroy_entity_type
    assert_difference('EntityType.count', -1) do
      delete :destroy, :id => entity_types(:one).id
    end

    assert_redirected_to entity_types_path
  end
end
