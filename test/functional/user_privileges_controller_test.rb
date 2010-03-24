require File.dirname(__FILE__) + '/../test_helper'

class UserPrivilegesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:user_privileges)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_user_privilege
    assert_difference('UserPrivilege.count') do
      post :create, :user_privilege => { }
    end

    assert_redirected_to user_privilege_path(assigns(:user_privilege))
  end

  def test_should_show_user_privilege
    get :show, :id => user_privileges(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => user_privileges(:one).id
    assert_response :success
  end

  def test_should_update_user_privilege
    put :update, :id => user_privileges(:one).id, :user_privilege => { }
    assert_redirected_to user_privilege_path(assigns(:user_privilege))
  end

  def test_should_destroy_user_privilege
    assert_difference('UserPrivilege.count', -1) do
      delete :destroy, :id => user_privileges(:one).id
    end

    assert_redirected_to user_privileges_path
  end
end
