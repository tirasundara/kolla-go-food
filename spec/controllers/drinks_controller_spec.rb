require 'rails_helper'

RSpec.describe DrinksController, type: :controller do
  describe "GET #index" do
    context "without letter param" do
      it "populates an array of all drinks" do
        drink1 = create(:drink, name: 'Sprite')
        drink2 = create(:drink, name: 'Coca Cola')
        get :index
        expect(assigns(:drinks)).to match_array([drink1, drink2])
      end
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
    context "with letter params" do
      it "populates an array of all fods starting with the param letter" do
        strawberry = create(:drink, name: 'Strawberry Juice')
        sugar = create(:drink, name: 'Sugar Water')
        coffee = create(:drink, name: 'Cofee')
        get :index, params: { letter: 'S' }
        expect(assigns(:drinks)).to match_array([strawberry, sugar])
      end
      it "render the :index template" do
        get :index, params: { letter: 'S' }
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested drink to @drink" do
      drink = create(:drink)
      get :show, params: { id: drink }
      expect(assigns(:drink)).to eq drink
    end
    it "render the :show template" do
      drink = create(:drink)
      get :show, params: { id: drink }
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new Drink to @drink" do
      get :new
      expect(assigns(:drink)).to be_a_new(Drink)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    it "assigns the requested drink to @drink" do
      drink = create(:drink)
      get :edit, params: { id: drink }
      expect(assigns(:drink)).to eq drink
    end
    it "renders the :edit template" do
      drink = create(:drink)
      get :edit, params: { id: drink }
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    # if category is mandatory, Uncomment these lines
    # before :each do
    #  @category = create(:category)
    # end
    context "with valid attributes" do
      it "save the new drink in the databse" do
        expect{
          post :create, params: { drink: attributes_for(:drink) } # uncomment me too .merge(category_id: @category.id) }
        }.to change(Drink, :count).by(1)
      end
      it "redirects to :show template" do
        post :create, params: { drink: attributes_for(:drink) }
        # raise attributes_for(:drink).to_json
        # raise assigns[:drink].errors.to_json
        expect(response).to redirect_to(drink_path(assigns[:drink]))
      end
    end

    context "with invalid attributes" do
      it "does not save drink in the databse" do
        expect{
          post :create, params: { drink: attributes_for(:invalid_drink) }
        }.not_to change(Drink, :count)
      end
      it "re-renders the :new template" do
        post :create, params: { drink: attributes_for(:invalid_drink) }
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @drink = create(:drink)
    end

    context "with valid attributes" do
      it "locates the requested @drink" do
        patch :update, params: { id: @drink, drink: attributes_for(:drink) }
        expect(assigns(:drink)).to eq @drink
      end
      it "changes @drink's attributes" do
        patch :update, params: { id: @drink, drink: attributes_for(:drink, name: 'Indomilk') }
        @drink.reload
        expect(@drink.name).to eq 'Indomilk'
      end
      it "redirects to the drink" do
        patch :update, params: { id: @drink, drink: attributes_for(:drink) }
        expect(response).to redirect_to @drink
      end
    end

    context "with invalid attributes" do
      it "does not save the drink in the database" do
        patch :update, params: { id: @drink, drink: attributes_for(:drink, name: 'Indomilk', description: nil) }
        @drink.reload
        expect(@drink.name).not_to eq 'Indomilk'
      end
      it "re-renders the :edit template" do
        patch :update, params: { id: @drink, drink: attributes_for(:invalid_drink) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @drink = create(:drink)
    end
    it "removes the drink from the database" do
      expect {
        delete :destroy, params: { id: @drink }
      }.to change(Drink, :count).by(-1)
    end
    it "redirects to :index template" do
      delete :destroy, params: { id: @drink }
      expect(response).to redirect_to drinks_path
    end
  end
end
