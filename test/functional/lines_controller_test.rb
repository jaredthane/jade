require File.dirname(__FILE__) + '/../test_helper'

class LinesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:lines)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_line
    assert_difference('Line.count') do
      post :create, :line => { }
    end

    assert_redirected_to line_path(assigns(:line))
  end

  def test_should_show_line
    get :show, :id => lines(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => lines(:one).id
    assert_response :success
  end

  def test_should_update_line
    put :update, :id => lines(:one).id, :line => { }
    assert_redirected_to line_path(assigns(:line))
  end

  def test_should_destroy_line
    assert_difference('Line.count', -1) do
      delete :destroy, :id => lines(:one).id
    end

    assert_redirected_to lines_path
  end
end
