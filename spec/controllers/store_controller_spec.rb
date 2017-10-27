require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns a list of foods, ordered by name" do
      nasi_uduk = create(:food, name: "Nasi Uduk")
      kerak_telor = create(:food, name: "Kerak Telor")
      get :index
      expect(assigns(:foods)).to eq([kerak_telor, nasi_uduk])
    end
  end

end
