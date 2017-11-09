require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe "GET #new" do
    it "assigns Review to @review" do
      get :new
      expect(assigns[:review]).to be_a_new(Review)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      
    end
    context "with invalid attributes" do

    end
  end
end
