require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    # it "returns a list of foods, ordered by name" do
    #   nasi_uduk = create(:food, name: "Nasi Uduk")
    #   kerak_telor = create(:food, name: "Kerak Telor")
    #   get :index
    #   expect(assigns(:foods)).to eq([kerak_telor, nasi_uduk])
    # end

    it "returns a list of restaurants" do
        restaurant1 = create(:restaurant, name: "RM number 1")
        restaurant2 = create(:restaurant, name: "RM number 2", address: 'Jl LOL')
        get :index
        expect(assigns[:restaurants]).to match_array([restaurant1, restaurant2])
    end

    it "includes CurrentCart" do
      expect(StoreController.ancestors.include? CurrentCart).to eq(true)
    end
  end

end
