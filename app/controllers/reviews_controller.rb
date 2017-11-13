class ReviewsController < ApplicationController
  before_action :load_reviewable
  skip_before_action :authorize

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.where(reviewable_id: @reviewable.id)
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @reviewable, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def load_reviewable
      if params[:food_id]
        @reviewable = Food.find_by(id: params[:food_id])
      elsif params[:restaurant_id]
        @reviewable = Restaurant.find_by(id: params[:restaurant_id])
      end
    end

    def review_params
      params.require(:review).permit(:name, :title, :description, :reviewable_id, :reviewable_type)
    end
end

# class ReviewsController < ApplicationController
#   before_action :load_reviewable
#
#   def index
#
#   end
#
#   def new
#     # @reviewable = load_reviewable
#     @review = @reviewable.reviews.new
#   end
#
#   def create
#     # @review = Review.new(review_params)
#     @review = @reviewable.reviews.new(review_params)
#     respond_to do |format|
#       if @review.save
#         format.html { redirect_to store_index_path, notice: 'Review was successfully created.' }
#         format.json { render :show, status: :ok, location: @review }
#       else
#         format.html { render :new }
#         format.json { render json: @review.errors, status: :unprocessable_entity}
#       end
#     end
#   end
#
#   def edit
#
#   end
#
#   def destroy
#
#   end
#
#   def update
#
#   end
#
#   private
#     def load_reviewable
#       klass = [Food, Restaurant].detect { |c| params["#{c.name.underscore}_id"] }
#       @reviewable = klass.find(params["#{klass.name.underscore}_id"])
#       # resource, id = request.path.split('/')[1,2]
#       # @reviewable = resource.singularize.classify.constantize.find(id)
#     end
#
#     def review_params
#       params.require(:review).permit(:name, :title, :description)
#     end
# end
