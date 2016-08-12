require "rails_helper"

RSpec.describe Forecast24sController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forecast_24s").to route_to("forecast_24s#index")
    end

    it "routes to #new" do
      expect(:get => "/forecast_24s/new").to route_to("forecast_24s#new")
    end

    it "routes to #show" do
      expect(:get => "/forecast_24s/1").to route_to("forecast_24s#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forecast_24s/1/edit").to route_to("forecast_24s#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forecast_24s").to route_to("forecast_24s#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forecast_24s/1").to route_to("forecast_24s#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forecast_24s/1").to route_to("forecast_24s#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forecast_24s/1").to route_to("forecast_24s#destroy", :id => "1")
    end

  end
end
