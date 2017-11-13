require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end
  describe "GET #index" do
    it "populates an array of all users" do
      user1 = create(:user, username: "Anugrah")
      user2 = create(:user, username: "Badi")
      get :index
      expect(assigns(:users)).to match_array([@user, user1, user2])
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested user to @user" do
      user = create(:user)
      get :show, params: { id: user }
      expect(assigns(:user)).to eq(user)
    end
    it "renders the :show template" do
      user = create(:user)
      get :show, params: { id: user}
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do

  end

  describe "GET #edit" do
    it "assigns the requested user to @user" do
      user = create(:user)
      get :edit, params: { id: user }
      expect(assigns(:user)).to eq(user)
    end
    it "renders the :edit template" do
      user = create(:user)
      get :edit, params: { id: user}
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before :each do
      user = create(:user)
      session[:user_id] = user.id
    end

    it "assigns 200000 credit to new users" do
      user = create(:user)
      expect(user.credit).to eq 200000.00
    end

    it "saves the new user in the database" do
      role1 = create(:role)
      role2 = create(:role)
      user = create(:user, password: 'oldpassword', password_confirmation: 'oldpassword')
      expect {
        post :create, params: { user: attributes_for(:user, role_ids: [role1.id, role2.id]) }
      }.to change(User, :count).by(1)
    end

    it "is redirects to user#show" do
      post :create, params: { user: attributes_for(:user) }
      expect(response).to redirect_to(user_path(assigns[:user]))
    end
  end

  describe "PATCH #update" do
    before :each do
      @user = create(:user)
    end
    context "with valid attributes" do
      it "locates the requested user" do

      end
      it "saves the new password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('newlongpassword')).to eq(@user)
      end

      it "redirects to user#index" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to(user_path(assigns[:user]))
      end

      it "disables login with old password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword')}
        @user.reload
        expect(@user.authenticate('oldpassword')).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the user in the database" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: nil, password_confirmation: nil) }
        @user.reload
        expect(@user.authenticate(nil)).to eq(false)
      end
      it "re-renders the :edit template" do
        patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @user = create(:user)
    end
    it "deletes user from the database" do
      expect{
        delete :destroy, params: { id: @user }
      }.to change(User, :count).by(-1)
    end
    it "redirects to user#index" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to users_path
    end
  end

  it "is a test" do
    user = create(:user)
    patch :update, params: { id: user, user: attributes_for(:user, credit: 100000.0) }
    user.reload
    expect(@user.credit.to_f).to eq(100000)
  end
end
