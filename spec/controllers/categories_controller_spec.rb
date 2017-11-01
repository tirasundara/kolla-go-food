require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it "populates an array of all categories" do
    dessert = create(:category, name: 'Dessert')
    main_course = create(:category, name: 'Main Course')
    get :index  # http request get ke aksi index
    expect(assigns(:categories)).to match_array([dessert, main_course])
    # assigns mengecek instance variabel bernama @categories
  end

  it "renders the :index template" do
    get :index
    expect(response).to render_template :index
    # response memberikan template apakah itu html apakah itu json
  end

  it "assigns the requested category to @category" do
    category = create(:category)
    get :show, params: { id: category } # sebenarnya id: meng-ekspektasi id: category.id tapi karena ruby sudah punya konvensi bahwa id dari objek category adalah category.id maka programmer cukup menuliskan objek category saja
    expect(assigns(:category)).to eq category
  end

  it "populates a list of all foods in the category" do
    category = create(:category)
    food1 = create(:food, category: category)
    food2 = create(:food, category: category)
    get :show, params { id: category }
    expect(assigns(:category).foods).to match_array([food1, food2])
  end

  it "renders :show template" do
    category = create(:category)
    get :show, params { id: category }
    expect(response).to render_template :show
  end

  describe "GET#new" do
    it "assigns a new category to @category" do
      get :new
      expect(assigns(:category)).to be_a_new(category)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET#edit" do
    it "assigns the requested category to @category" do
      category = create(:category)
      get :edit, params { id: category }
      expect(assigns(:category)).to eq category
    end
    it "renders the edit template" do
      category = create(:category)
      get :edit, params: { id: category }
      expect(response).to render_template :edit
    end
  end

  describe "POST#create" do
    context "with valid attributes" do
      it "saves the new category in the database" do
        expect{
          post :create, params: { category: attributes_for(:category) }
        }.to change(Category, :count).by(1)
      end

      it "redirects to category#show" do
        post :create, params: { category: attributes_for(:category) }
        expect(response).to redirect_to(category_path(assigns[:category]))
      end
    end

    context "with invalid attributes" do
      it "does not save the new category in the database" do
        expect{
          post :create, params: { category: attributes_for(:invalid_category) }
        }.not_to change(Category, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { category: attributes_for(:invalid_category) }
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE#destroy" do
    before :each do
      @category = create(:category)
    end
    context "with associated foods" do
      it "does not delete the category from the database" do
        food = create(:food, category: @category)
        expect{
          delete :destroy, params: { id: @category }
        }.not_to change(Category, :count)
      end
    end

    context "without associated foods" do
      it "deletes the category from the database" do
        expect{
          delete :destroy, params: { id: @category }
        }.to change(Category, :count).by(-1)
      end

      it "redirects to categories#index" do
        delete :destroy, params: { id: @category }
        expect(response).to redirect_to categories_url
      end
    end
  end
end
