require 'rails_helper'

describe ReviewsController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id

    @food = create(:food)
    @food_review1 = create(:food_review, reviewable: @food)
    @food_review2 = create(:food_review, reviewable: @food)

    @restaurant = create(:restaurant)
    @restaurant_review1 = create(:restaurant_review, reviewable: @restaurant)
    @restaurant_review2 = create(:restaurant_review, reviewable: @restaurant)
  end

  context "with food as reviewable" do
    describe 'GET #index' do
      it "populates an array of all food reviews" do
        get :index, params: { food_id: @food.id }
        expect(assigns(:reviews)).to match_array([@food_review1, @food_review2])
      end

      it "renders the :index template" do
        get :index, params: { food_id: @food.id }
        expect(response).to render_template :index
      end
    end

    describe 'GET #new' do
      it "assigns a new Review to @review" do
        get :new, params: { food_id: @food.id }
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "renders the :new template" do
        get :new, params: { food_id: @food.id }
        expect(:response).to render_template :new
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it "saves the new review in the database" do
          expect{
            post :create, params: {
              review: attributes_for(:food_review, reviewable_id: @food.id, reviewable_type: @food.class.name),
              food_id: @food.id
            }
          }.to change(Review, :count).by(1)
        end

        it "redirects to food show page" do
          post :create, params: {
            review: attributes_for(:food_review, reviewable_id: @food.id, reviewable_type: @food.class.name),
            food_id: @food.id
          }
          expect(response).to redirect_to @food
        end
      end

      context "with invalid attributes" do
        it "does not save the new review in the database" do
          expect{
            post :create, params: { review: attributes_for(:invalid_food_review), food_id: @food.id }
          }.not_to change(Review, :count)
        end

        it "re-renders the :new template" do
          post :create, params: { review: attributes_for(:invalid_food_review), food_id: @food.id }
          expect(response).to render_template :new
        end
      end
    end
  end

  context "with restaurant as reviewable" do
    describe 'GET #index' do
      it "populates an array of all restaurant reviews" do
        get :index, params: { restaurant_id: @restaurant.id }
        expect(assigns(:reviews)).to match_array([@restaurant_review1, @restaurant_review2])
      end

      it "renders the :index template" do
        get :index, params: { restaurant_id: @restaurant.id }
        expect(response).to render_template :index
      end
    end

    describe 'GET #new' do
      it "assigns a new Review to @review" do
        get :new, params: { restaurant_id: @restaurant.id }
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "renders the :new template" do
        get :new, params: { restaurant_id: @restaurant.id }
        expect(:response).to render_template :new
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it "saves the new review in the database" do
          expect{
            post :create, params: {
              review: attributes_for(:restaurant_review, reviewable_id: @restaurant.id, reviewable_type: @restaurant.class.name),
              restaurant_id: @restaurant.id
            }
          }.to change(Review, :count).by(1)
        end

        it "redirects to restaurant show page" do
          post :create, params: {
            review: attributes_for(:restaurant_review, reviewable_id: @restaurant.id, reviewable_type: @restaurant.class.name),
            restaurant_id: @restaurant.id
          }
          expect(response).to redirect_to @restaurant
        end
      end

      context "with invalid attributes" do
        it "does not save the new review in the database" do
          expect{
            post :create, params: { review: attributes_for(:invalid_restaurant_review), restaurant_id: @restaurant.id }
          }.not_to change(Review, :count)
        end

        it "re-renders the :new template" do
          post :create, params: { review: attributes_for(:invalid_restaurant_review), restaurant_id: @restaurant.id }
          expect(response).to render_template :new
        end
      end
    end
  end
end
