require File.dirname(__FILE__) + '/../test_helper'

class RolesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_role
    assert_difference('Role.count') do
      post :create, :role => { }
    end

    assert_redirected_to role_path(assigns(:role))
  end

  def test_should_show_role
    get :show, :id => roles(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => roles(:one).id
    assert_response :success
  end

  def test_should_update_role
    put :update, :id => roles(:one).id, :role => { }
    assert_redirected_to role_path(assigns(:role))
  end

  def test_should_destroy_role
    assert_difference('Role.count', -1) do
      delete :destroy, :id => roles(:one).id
    end

    assert_redirected_to roles_path
  end
end
