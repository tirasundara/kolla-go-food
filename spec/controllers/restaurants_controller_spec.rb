require 'rails_helper'

RSpec.describe RestaurantsController do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end
  describe "GET #index" do
    it "populates an array of restaurants" do
      restaurant1 = create(:restaurant, name: "RM Enaq", address: "Jl A")
      restaurant2 = create(:restaurant, name: "RM Mantaf")
      get :index
      expect(assigns[:restaurants]).to match_array([restaurant1, restaurant2])
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #new" do
    it "assigns Restaurant to @restaurant" do
      get :new
      expect(assigns[:restaurant]).to be_a_new(Restaurant)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    before :each do
      @restaurant = create(:restaurant)
    end
    it "assigns the requested restaurant to @restaurant" do
      get :show, params: { id: @restaurant }
      expect(assigns[:restaurant]).to eq(@restaurant)
    end
    it "renders the :show template" do
      get :show, params: { id: @restaurant }
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do
    before :each do
      @restaurant = create(:restaurant)
    end
    it "assigns requested restaurant to @restaurant" do
      get :edit, params: { id: @restaurant }
      expect(assigns[:restaurant]).to eq(@restaurant)
    end
    it "renders the :edit template" do
      get :edit, params: { id: @restaurant }
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new @restaurant in the database" do
        expect {
          post :create, params: { restaurant: attributes_for(:restaurant) }
        }.to change(Restaurant, :count).by(1)
      end
      it "redirects to the :show restaurant" do
        post :create, params: { restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to restaurant_path(assigns[:restaurant])
      end
    end
    context "with invalid attributes" do
      it "does not save @restaurant in the database" do
        expect {
          post :create, params: { restaurant: attributes_for(:invalid_restaurant) }
        }.not_to change(Restaurant, :count)
      end
      it "re-renders the :new template" do
        post :create, params: { restaurant: attributes_for(:invalid_restaurant) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @restaurant = create(:restaurant)
    end
    context "with valid attributes" do
      it "locates the requested restaurant to @restaurant" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant) }
        expect(assigns[:restaurant]).to eq(@restaurant)
      end
      it "changes the @restaurant's attributes" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant, name: 'RM Bogaraso') }
        @restaurant.reload
        expect(@restaurant.name).to eq('RM Bogaraso')
      end
      it "redirects to :show template" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:restaurant) }
        expect(response).to redirect_to @restaurant
      end
    end
    context "with invalid attributes" do
      it "does not change the @restaurant's attributes" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:invalid_restaurant, name: "RM edit") }
        @restaurant.reload
        expect(@restaurant.name).not_to eq('RM edit')
      end
      it "re-renders the :edit template" do
        patch :update, params: { id: @restaurant, restaurant: attributes_for(:invalid_restaurant) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @restaurant = create(:restaurant)
    end
    it "deletes @restaurant from the database" do
      expect {
        delete :destroy, params: { id: @restaurant }
      }.to change(Restaurant, :count).by(-1)
    end
    it "redirects to restaurant :index" do
      delete :destroy, params: { id: @restaurant }
      expect(response).to redirect_to restaurants_path
    end
  end
end
