require File.dirname(__FILE__) + '/../spec_helper'

describe ServiceCallsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => ServiceCall.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    ServiceCall.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    ServiceCall.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(service_call_url(assigns[:service_call]))
  end

  it "edit action should render edit template" do
    get :edit, :id => ServiceCall.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    ServiceCall.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ServiceCall.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    ServiceCall.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ServiceCall.first
    response.should redirect_to(service_call_url(assigns[:service_call]))
  end

  it "destroy action should destroy model and redirect to index action" do
    service_call = ServiceCall.first
    delete :destroy, :id => service_call
    response.should redirect_to(service_calls_url)
    ServiceCall.exists?(service_call.id).should be_false
  end
end
