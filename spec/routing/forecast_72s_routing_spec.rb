require "rails_helper"

RSpec.describe Forecast72sController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forecast_72s").to route_to("forecast_72s#index")
    end

    it "routes to #new" do
      expect(:get => "/forecast_72s/new").to route_to("forecast_72s#new")
    end

    it "routes to #show" do
      expect(:get => "/forecast_72s/1").to route_to("forecast_72s#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forecast_72s/1/edit").to route_to("forecast_72s#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forecast_72s").to route_to("forecast_72s#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forecast_72s/1").to route_to("forecast_72s#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forecast_72s/1").to route_to("forecast_72s#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forecast_72s/1").to route_to("forecast_72s#destroy", :id => "1")
    end

  end
end
