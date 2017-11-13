require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end
  describe "GET #index" do
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

end
