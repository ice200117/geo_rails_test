require "rails_helper"

RSpec.describe Forecast48sController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/forecast_48s").to route_to("forecast_48s#index")
    end

    it "routes to #new" do
      expect(:get => "/forecast_48s/new").to route_to("forecast_48s#new")
    end

    it "routes to #show" do
      expect(:get => "/forecast_48s/1").to route_to("forecast_48s#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/forecast_48s/1/edit").to route_to("forecast_48s#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/forecast_48s").to route_to("forecast_48s#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forecast_48s/1").to route_to("forecast_48s#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forecast_48s/1").to route_to("forecast_48s#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forecast_48s/1").to route_to("forecast_48s#destroy", :id => "1")
    end

  end
end
