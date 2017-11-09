class ReviewsController < ApplicationController
  before_action :load_reviewable

  def index

  end

  def new
    # @reviewable = load_reviewable
    @review = @reviewable.reviews.new
  end

  def create
    # @review = Review.new(review_params)
    @review = @reviewable.reviews.new(review_params)
    respond_to do |format|
      if @review.save
        format.html { redirect_to [@reviewable, :reviews], notice: 'Review was successfully created.' }
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
      # resource, id = request.path.split('/')[1,2]
      # @reviewable = resource.singularize.classify.constantize.find(id)
    end

    def review_params
      params.require(:review).permit(:name, :title, :description)
    end
end
