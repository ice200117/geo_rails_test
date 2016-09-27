require "rails_helper"

RSpec.describe StationDailiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/station_dailies").to route_to("station_dailies#index")
    end

    it "routes to #new" do
      expect(:get => "/station_dailies/new").to route_to("station_dailies#new")
    end

    it "routes to #show" do
      expect(:get => "/station_dailies/1").to route_to("station_dailies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/station_dailies/1/edit").to route_to("station_dailies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/station_dailies").to route_to("station_dailies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/station_dailies/1").to route_to("station_dailies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/station_dailies/1").to route_to("station_dailies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/station_dailies/1").to route_to("station_dailies#destroy", :id => "1")
    end

  end
end
