require File.dirname(__FILE__) + '/../spec_helper'

describe ProvidersController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Provider.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Provider.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(provider_url(assigns[:provider]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Provider.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Provider.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Provider.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Provider.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Provider.first
    response.should redirect_to(provider_url(assigns[:provider]))
  end

  it "destroy action should destroy model and redirect to index action" do
    provider = Provider.first
    delete :destroy, :id => provider
    response.should redirect_to(providers_url)
    Provider.exists?(provider.id).should be_false
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Provider.first
    response.should render_template(:show)
  end
end
