require "spec_helper"

describe BomsController do
  describe "routing" do

    it "routes to #index" do
      get("/boms").should route_to("boms#index")
    end

    it "routes to #new" do
      get("/boms/new").should route_to("boms#new")
    end

    it "routes to #show" do
      get("/boms/1").should route_to("boms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/boms/1/edit").should route_to("boms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/boms").should route_to("boms#create")
    end

    it "routes to #update" do
      put("/boms/1").should route_to("boms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/boms/1").should route_to("boms#destroy", :id => "1")
    end

  end
end
