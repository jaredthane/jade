require File.dirname(__FILE__) + '/../test_helper'

class ComboLinesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:combo_lines)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_combo_line
    assert_difference('ComboLine.count') do
      post :create, :combo_line => { }
    end

    assert_redirected_to combo_line_path(assigns(:combo_line))
  end

  def test_should_show_combo_line
    get :show, :id => combo_lines(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => combo_lines(:one).id
    assert_response :success
  end

  def test_should_update_combo_line
    put :update, :id => combo_lines(:one).id, :combo_line => { }
    assert_redirected_to combo_line_path(assigns(:combo_line))
  end

  def test_should_destroy_combo_line
    assert_difference('ComboLine.count', -1) do
      delete :destroy, :id => combo_lines(:one).id
    end

    assert_redirected_to combo_lines_path
  end
end
