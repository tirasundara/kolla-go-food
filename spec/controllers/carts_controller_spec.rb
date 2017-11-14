require 'rails_helper'

describe CartsController do

  # This should return the minimal set of attributes required to create a valid
  # Cart. As you add validations to Cart, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CartsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end

  describe "GET index" do
    it "assigns all carts as @carts" do
      cart = Cart.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:carts)).to eq([cart])
    end
  end

  describe "GET show" do
    it "assigns the requested cart as @cart" do
      cart = Cart.create! valid_attributes
      get :show, params: {:id => cart.to_param}
      expect(assigns(:cart)).to eq(cart)
    end

    it "displays its line_items" do
      cart = create(:cart)

      food1 = create(:food)
      line_item1 = create(:line_item, food: food1, cart: cart)

      food2 = create(:food)
      line_item2 = create(:line_item, food: food2, cart: cart)

      get :show, params: { id: cart }
      expect(assigns(:cart).line_items).to match_array([line_item1, line_item2])
    end
  end

  describe "GET new" do
    it "assigns a new cart as @cart" do
      get :new
      expect(assigns(:cart)).to be_a_new(Cart)
    end
  end

  describe "GET edit" do
    it "assigns the requested cart as @cart" do
      cart = Cart.create! valid_attributes
      get :edit, params: {:id => cart.to_param}
      expect(assigns(:cart)).to eq(cart)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Cart" do
        expect {
          post :create, params: { cart: valid_attributes}
        }.to change(Cart, :count).by(1)
      end

      it "assigns a newly created cart as @cart" do
        post :create, params: { cart: valid_attributes }
        expect(assigns(:cart)).to be_a(Cart)
        expect(assigns(:cart)).to be_persisted
      end

      it "redirects to the created cart" do
        post :create, params: { cart: valid_attributes }
        expect(response).to redirect_to(Cart.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cart as @cart" do
        post :create, params: { cart: invalid_attributes }
        expect(assigns(:cart)).to be_a_new(Cart)
      end

      it "re-renders the 'new' template" do
        post :create, {:cart => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested cart" do
        cart = Cart.create! valid_attributes
        put :update, params: { id: cart.to_param, cart: new_attributes }
        cart.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested cart as @cart" do
        cart = Cart.create! valid_attributes
        put :update, params: { id: cart.to_param, cart: valid_attributes }
        expect(assigns(:cart)).to eq(cart)
      end

      it "redirects to the cart" do
        cart = Cart.create! valid_attributes
        put :update, params: { id: cart.to_param, cart: valid_attributes }
        expect(response).to redirect_to(cart)
      end
    end

    describe "with invalid params" do
      it "assigns the cart as @cart" do
        cart = Cart.create! valid_attributes
        put :update, params: { id: cart.to_param, cart: invalid_attributes }
        expect(assigns(:cart)).to eq(cart)
      end

      it "re-renders the 'edit' template" do
        cart = Cart.create! valid_attributes
        put :update, params: { id: cart.to_param, cart: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @cart = create(:cart)
      session[:cart_id] = @cart.id
      session[:restaurant_id] = 1
    end

    context "with valid cart id" do
      it "destroys the requested cart" do
        expect {
          delete :destroy, params: { id: @cart.id }
        }.to change(Cart, :count).by(-1)
      end

      it "removes the cart from user's session" do
        delete :destroy, params: { id: @cart.id }
        expect(session[:id]).to eq(nil)
      end

      it "removes restaurant_id from user's session" do
        delete :destroy, params: { id: @cart.id }
        expect(session[:restaurant_id]).to eq(nil)
      end

      it "redirects to the store home page" do
        delete :destroy, params: { id: @cart.id }
        expect(response).to redirect_to(store_index_url)
      end
    end

    context "with invalid cart id" do
      it "does not destroy the requested cart" do
        other_cart = create(:cart)

        expect{
          delete :destroy, params: { id: other_cart.id }
        }.not_to change(Cart, :count)
      end
    end
  end

end
