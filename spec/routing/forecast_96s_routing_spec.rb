require "rails_helper"

RSpec.describe Forecast96sController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forecast_96s").to route_to("forecast_96s#index")
    end

    it "routes to #new" do
      expect(:get => "/forecast_96s/new").to route_to("forecast_96s#new")
    end

    it "routes to #show" do
      expect(:get => "/forecast_96s/1").to route_to("forecast_96s#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forecast_96s/1/edit").to route_to("forecast_96s#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forecast_96s").to route_to("forecast_96s#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forecast_96s/1").to route_to("forecast_96s#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forecast_96s/1").to route_to("forecast_96s#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forecast_96s/1").to route_to("forecast_96s#destroy", :id => "1")
    end

  end
end
