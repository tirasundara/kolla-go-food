require 'rails_helper'

describe BuyersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end
  describe 'GET #index' do
    context 'with params[:letter]' do
      it "populates an array of buyers starting with the letter" do
        risal = create(:buyer, name: "Risal")        # berkaitan dengan FactoryGirl yang udah kita define di spec/factories/food.rb
        kahpi = create(:buyer, name: "Kahpi")        # ini juga sama. Method create adalah bawaan FactoryGirl yang kita define di config
        # kerak_telor = create(:food, name: "Kerak Telor")
        get :index, params: { letter: 'R' }
        expect(assigns(:buyers)).to match_array([risal]) # sedangkan assigns adalah method bawaan rails sehingga foods yang dimaksud adalah
                                                            # @foods pada controller food
      end

      it "renders the :index template" do
        get :index, params: { letter: 'R' }
        expect(response).to render_template :index
      end
    end

    context 'without params[:letter]' do
      it "populates an array of all buyers" do
        risal = create(:buyer, name: "Risal")
        kahpi = create(:buyer, name: "Kahpi")
        get :index
        expect(assigns(:buyers)).to match_array([risal, kahpi])
      end
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    it "assigns a new Buyer to @buyer" do
      get :new
      expect(assigns(:buyer)).to be_a_new(Buyer)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #show' do
    it "assigns the requested buyer to @buyer" do
      buyer = create(:buyer)
      get :show, params: { id: buyer }
      expect(assigns(:buyer)).to eq buyer
    end
    it "renders the :show template" do
      buyer = create(:buyer)
      get :show, params: { id: buyer }
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    it "assigns the requested buyer to @buyer" do
      buyer = create(:buyer)
      get :edit, params: { id: buyer }
      expect(assigns(:buyer)).to eq buyer
    end
    it "renders the :edit template" do
      buyer = create(:buyer)
      get :edit, params: { id: buyer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "save the new buyer in the database" do
        expect{
          post :create, params: { buyer: attributes_for(:buyer) }
        }.to change(Buyer, :count).by(1)
      end
      it "redirects to buyer#show" do
        post :create, params: { buyer: attributes_for(:buyer) }
        expect(response).to redirect_to(buyer_path(assigns[:buyer]))
      end
    end

    context "with invalid attributes" do
      it "does not save the new buyer in the database" do
        expect{
          post :create, params: { buyer: attributes_for(:invalid_buyer) }
        }.not_to change(Buyer, :count) # ini maksudnya kita mau pake method count dari class Food
                                      # udah ada banyak method yang otomatis dibuat sama ruby seperti count, where, find. Cek di rails c
      end
      it "re-renders the :new template" do
        post :create, params: { buyer: attributes_for(:invalid_buyer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @buyer = create(:buyer)
    end

    context "with valid attributes" do
      it "locates the requested @buyer" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer) }
        expect(assigns(:buyer)).to eq @buyer
      end
      it "changes @buyer's attributes" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer, name: 'Marjan') }
        @buyer.reload
        expect(@buyer.name).to eq('Marjan')
      end
      it "redirects to the buyer" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer) }
        expect(response).to redirect_to @buyer
      end
    end
    context "with invalid attributes" do
      it "does not update the food in the database" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:buyer, name: 'Risal', address: nil) }
        @buyer.reload
        expect(@buyer.name).not_to eq('Risal')
      end
      it "re-renders the :edit template" do
        patch :update, params: { id: @buyer, buyer: attributes_for(:invalid_buyer) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @buyer = create(:buyer)
    end

    it "deteles the buyer from the database" do
      expect{
        delete :destroy, params: { id: @buyer }
      }.to change(Buyer, :count).by(-1)
    end
    it "redirects to buyers#index" do
      delete :destroy, params: { id: @buyer }
      expect(response).to redirect_to buyers_url
    end
  end

end
