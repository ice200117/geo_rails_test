require "rails_helper"

RSpec.describe CityDailiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/city_dailies").to route_to("city_dailies#index")
    end

    it "routes to #new" do
      expect(:get => "/city_dailies/new").to route_to("city_dailies#new")
    end

    it "routes to #show" do
      expect(:get => "/city_dailies/1").to route_to("city_dailies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/city_dailies/1/edit").to route_to("city_dailies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/city_dailies").to route_to("city_dailies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/city_dailies/1").to route_to("city_dailies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/city_dailies/1").to route_to("city_dailies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/city_dailies/1").to route_to("city_dailies#destroy", :id => "1")
    end

  end
end
