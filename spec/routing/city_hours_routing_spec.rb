require "rails_helper"

RSpec.describe CityHoursController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/city_hours").to route_to("city_hours#index")
    end

    it "routes to #new" do
      expect(:get => "/city_hours/new").to route_to("city_hours#new")
    end

    it "routes to #show" do
      expect(:get => "/city_hours/1").to route_to("city_hours#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/city_hours/1/edit").to route_to("city_hours#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/city_hours").to route_to("city_hours#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/city_hours/1").to route_to("city_hours#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/city_hours/1").to route_to("city_hours#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/city_hours/1").to route_to("city_hours#destroy", :id => "1")
    end

  end
end
