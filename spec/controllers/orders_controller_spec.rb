require 'rails_helper'

describe OrdersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end
  it "includes CurrentCart" do
    expect(OrdersController.ancestors.include? CurrentCart).to eq(true)
  end

  describe "GET #index" do

    it "populates an array of all orders" do
      order1 = create(:order, name: "Buyer 1", voucher_id: 1, total_price: 2000.0)
      order2 = create(:order, name: "Buyer 2", voucher_id: 1, total_price: 33000.0)

      get :index
      expect(assigns(:orders)).to match_array([order1, order2])
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested order to @order" do
      order = create(:order)
      get :show, params: { id: order }
      expect(assigns(:order)).to eq order
    end
    it "renders the :show template" do
      order = create(:order)
      get :show, params: { id: order }
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    context "with non-empty cart" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
        @line_item = create(:line_item, cart: @cart)
      end
      it "assigns new Order to order" do
        get :new
        expect(assigns(:order)).to be_a_new(Order)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end
    context "with empty cart" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
      end
      it "redirects to the store index page" do
        get :new
        expect(response).to redirect_to store_index_url
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested order to @order" do
      order = create(:order)
      get :edit, params: { id: order }
      expect(assigns(:order)).to eq order
    end
    it "renders the :edit template" do
      order = create(:order)
      get :edit, params: { id: order }
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before :each do
        @cart = create(:cart)
        session[:cart_id] = @cart.id
      end
      it "saves the new Order in the database" do
        expect{
          post :create, params: { order: attributes_for(:order) }
        }.to change(Order, :count).by(1)
      end
      it "destroys session's cart" do
        expect{
          post :create, params: { order: attributes_for(:order) }
        }.to change(Cart, :count).by(-1)
      end
      it "removes the cart from the session's params" do
        post :create, params: { order: attributes_for(:order) }
        expect(session[:cart_id]).to eq(nil)
      end
      it "redirects to store index page" do
        post :create, params: { order: attributes_for(:order) }
        expect(response).to redirect_to store_index_path
      end
      it "sends order confirmation email" do
        expect {
          post :create, params: { order: attributes_for(:order) }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
    context "with invalid attributes" do
      it "does not save the new Order in the database" do
        expect {
          post :create, params: { order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end
      it "re-renders the :new template" do
        post :create, params: { order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @order = create(:order)
    end
    context "with valid attributes" do
      it "locates the requested @order" do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(assigns(:order)).to eq @order
      end
      it "changes @order's attributes" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: 'Anugrah') }
        @order.reload
        expect(@order.name).to eq 'Anugrah'
      end
      it "redirects to the order" do
        patch :update, params: { id: @order, order: attributes_for(:order) }
        expect(response).to redirect_to @order
      end
    end
    context "with invalid attributes" do
      it "does not update the order in the database" do
        patch :update, params: { id: @order, order: attributes_for(:order, name: 'Marzan', email: nil) }
        @order.reload
        expect(@order.name).not_to eq 'Marzan'
      end
      it "re-renders the :edit template" do
        patch :update, params: { id: @order, order: attributes_for(:invalid_order) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @order = create(:order)
    end
    it "deletes order from the database" do
      expect{
        delete :destroy, params: { id: @order }
      }.to change(Order, :count).by(-1)
    end
    it "redirects to order#index" do
      delete :destroy, params: { id: @order }
      expect(response).to redirect_to orders_path
    end
  end


  it "assigns session[:user_id] to order.user_id" do
    post :create, params: { order: attributes_for(:order) }
    expect(assigns(:order).user_id).to eq(session[:user_id])
  end

  context "with gopay as payment_type" do
    it "returns true if user's credit is sufficient" do
      post :create, params: { order: attributes_for(:order, payment_type: 'Go Pay') }
      expect(assigns(:user).ensure_credit_is_sufficient(session[:user_id], assigns(:order).total_price)).to eq(true)
    end

    it "does not save order with insufficient credit" do
      cart = create(:cart)
      food1 = create(:food, price: 100000.00)
      food2 = create(:food, price: 121000.00)
      line_item1 = create(:line_item, cart: cart, food: food1, quantity: 2)
      line_item2 = create(:line_item, cart: cart, food: food2, quantity: 2)
      # order = build
      expect {
        post :create, params: { order: attributes_for(:order, line_items: [line_item1, line_item2], payment_type: 'Go Pay') }
      }.not_to change(Order, :count)
    end
  end
end
