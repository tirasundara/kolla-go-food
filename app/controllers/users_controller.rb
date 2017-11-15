class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :set_topup]
# before_action :validate_amount, only: :set_topup

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def edit
  end

  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'user was successfully updated.' }
        format.html { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'User was successfully deteled.' }
      format.json { head :no_content }
    end
  end

  def topup
  end

  def set_topup
    res = @user.topup(params[:amount])
    respond_to do |format|
      if @user.save && res
        format.html { redirect_to topup_user_path, notice: 'Top up success.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to topup_user_path, notice: 'Top up failed: amount is invalid' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :credit, :password_confirmation, role_ids: [])
    end

    # def validate_amount
    #   @user.ensure_amount_is_valid(params[:amount])
    # end
end
