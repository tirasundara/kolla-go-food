require 'rails_helper'

describe SessionsController do
  describe "GET #new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before :each do
      @user = create(:user, username: 'user1', password: 'oldpassword', password_confirmation: 'oldpassword')
    end
    context "with valid username and password" do
      it "assigns user_id to session variables" do
        post :create, params: { username: 'user1', password: 'oldpassword' }
        expect(session[:user_id]).to eq(@user.id)
      end
      it "redirects to admin index page" do
        post :create, params: { username: 'user1', password: 'oldpassword' }
        expect(response).to redirect_to admin_path
      end
    end
    context "with invalid username and password" do
      it "redirects to login page" do
        post :create, params: { username: 'user1', password: 'wrongpassword' }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @user = create(:user)
    end
    it "removes user_id from session variables" do
      delete :destroy, params: { id: @user  }
      expect(session[:user_id]).to eq(nil)
    end
    it "redirects user to login page" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to login_path
    end
  end
end
