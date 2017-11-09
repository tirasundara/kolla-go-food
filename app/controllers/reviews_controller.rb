class ReviewsController < ApplicationController
  before_action :load_reviewable, only: [:new]
  def new
    @reviewable = load_reviewable
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        format.html { redirect_to store_index_path, notice: 'Review was successfully created.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity}
      end
    end
  end

  def edit

  end

  def destroy

  end

  def update

  end

  private
    def load_reviewable
      klass = [Food, Restaurant].detect { |c| params["#{c.name.underscore}_id"] }
      @reviewable = klass.find(params["#{klass.name.underscore}_id"])
    end

    def review_params
      params.require(:review).permit(:name, :title, :description, :reviewable_id, :reviewable_type)
    end
end
