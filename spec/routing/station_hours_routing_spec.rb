require "rails_helper"

RSpec.describe StationHoursController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/station_hours").to route_to("station_hours#index")
    end

    it "routes to #new" do
      expect(:get => "/station_hours/new").to route_to("station_hours#new")
    end

    it "routes to #show" do
      expect(:get => "/station_hours/1").to route_to("station_hours#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/station_hours/1/edit").to route_to("station_hours#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/station_hours").to route_to("station_hours#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/station_hours/1").to route_to("station_hours#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/station_hours/1").to route_to("station_hours#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/station_hours/1").to route_to("station_hours#destroy", :id => "1")
    end

  end
end
