require "spec_helper"

describe ProvidersController do
  describe "routing" do

    it "routes to #index" do
      get("/providers").should route_to("providers#index")
    end

    it "routes to #new" do
      get("/providers/new").should route_to("providers#new")
    end

    it "routes to #show" do
      get("/providers/1").should route_to("providers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/providers/1/edit").should route_to("providers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/providers").should route_to("providers#create")
    end

    it "routes to #update" do
      put("/providers/1").should route_to("providers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/providers/1").should route_to("providers#destroy", :id => "1")
    end

  end
end
