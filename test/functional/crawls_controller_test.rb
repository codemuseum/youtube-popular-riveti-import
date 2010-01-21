require 'test_helper'

class CrawlsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crawls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crawl" do
    assert_difference('Crawl.count') do
      post :create, :crawl => { }
    end

    assert_redirected_to crawl_path(assigns(:crawl))
  end

  test "should show crawl" do
    get :show, :id => crawls(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => crawls(:one).to_param
    assert_response :success
  end

  test "should update crawl" do
    put :update, :id => crawls(:one).to_param, :crawl => { }
    assert_redirected_to crawl_path(assigns(:crawl))
  end

  test "should destroy crawl" do
    assert_difference('Crawl.count', -1) do
      delete :destroy, :id => crawls(:one).to_param
    end

    assert_redirected_to crawls_path
  end
end
