require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Forecast24sController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Forecast24. As you add validations to Forecast24, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Forecast24sController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all forecast_24s as @forecast_24s" do
      forecast_24 = Forecast24.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:forecast_24s)).to eq([forecast_24])
    end
  end

  describe "GET #show" do
    it "assigns the requested forecast_24 as @forecast_24" do
      forecast_24 = Forecast24.create! valid_attributes
      get :show, {:id => forecast_24.to_param}, valid_session
      expect(assigns(:forecast_24)).to eq(forecast_24)
    end
  end

  describe "GET #new" do
    it "assigns a new forecast_24 as @forecast_24" do
      get :new, {}, valid_session
      expect(assigns(:forecast_24)).to be_a_new(Forecast24)
    end
  end

  describe "GET #edit" do
    it "assigns the requested forecast_24 as @forecast_24" do
      forecast_24 = Forecast24.create! valid_attributes
      get :edit, {:id => forecast_24.to_param}, valid_session
      expect(assigns(:forecast_24)).to eq(forecast_24)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Forecast24" do
        expect {
          post :create, {:forecast_24 => valid_attributes}, valid_session
        }.to change(Forecast24, :count).by(1)
      end

      it "assigns a newly created forecast_24 as @forecast_24" do
        post :create, {:forecast_24 => valid_attributes}, valid_session
        expect(assigns(:forecast_24)).to be_a(Forecast24)
        expect(assigns(:forecast_24)).to be_persisted
      end

      it "redirects to the created forecast_24" do
        post :create, {:forecast_24 => valid_attributes}, valid_session
        expect(response).to redirect_to(Forecast24.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved forecast_24 as @forecast_24" do
        post :create, {:forecast_24 => invalid_attributes}, valid_session
        expect(assigns(:forecast_24)).to be_a_new(Forecast24)
      end

      it "re-renders the 'new' template" do
        post :create, {:forecast_24 => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested forecast_24" do
        forecast_24 = Forecast24.create! valid_attributes
        put :update, {:id => forecast_24.to_param, :forecast_24 => new_attributes}, valid_session
        forecast_24.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested forecast_24 as @forecast_24" do
        forecast_24 = Forecast24.create! valid_attributes
        put :update, {:id => forecast_24.to_param, :forecast_24 => valid_attributes}, valid_session
        expect(assigns(:forecast_24)).to eq(forecast_24)
      end

      it "redirects to the forecast_24" do
        forecast_24 = Forecast24.create! valid_attributes
        put :update, {:id => forecast_24.to_param, :forecast_24 => valid_attributes}, valid_session
        expect(response).to redirect_to(forecast_24)
      end
    end

    context "with invalid params" do
      it "assigns the forecast_24 as @forecast_24" do
        forecast_24 = Forecast24.create! valid_attributes
        put :update, {:id => forecast_24.to_param, :forecast_24 => invalid_attributes}, valid_session
        expect(assigns(:forecast_24)).to eq(forecast_24)
      end

      it "re-renders the 'edit' template" do
        forecast_24 = Forecast24.create! valid_attributes
        put :update, {:id => forecast_24.to_param, :forecast_24 => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested forecast_24" do
      forecast_24 = Forecast24.create! valid_attributes
      expect {
        delete :destroy, {:id => forecast_24.to_param}, valid_session
      }.to change(Forecast24, :count).by(-1)
    end

    it "redirects to the forecast_24s list" do
      forecast_24 = Forecast24.create! valid_attributes
      delete :destroy, {:id => forecast_24.to_param}, valid_session
      expect(response).to redirect_to(forecast_24s_url)
    end
  end

end
