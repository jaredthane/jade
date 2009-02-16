require File.dirname(__FILE__) + '/../test_helper'

class PrivilegesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:privileges)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_privilege
    assert_difference('Privilege.count') do
      post :create, :privilege => { }
    end

    assert_redirected_to privilege_path(assigns(:privilege))
  end

  def test_should_show_privilege
    get :show, :id => privileges(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => privileges(:one).id
    assert_response :success
  end

  def test_should_update_privilege
    put :update, :id => privileges(:one).id, :privilege => { }
    assert_redirected_to privilege_path(assigns(:privilege))
  end

  def test_should_destroy_privilege
    assert_difference('Privilege.count', -1) do
      delete :destroy, :id => privileges(:one).id
    end

    assert_redirected_to privileges_path
  end
end
