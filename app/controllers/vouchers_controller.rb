class VouchersController < ApplicationController
  # skip_before_action :authorize
  before_action :set_voucher, only: [:show, :edit, :update, :destroy]

  def index
    @vouchers = Voucher.all
  end

  def show

  end

  def edit

  end

  def new
    @voucher = Voucher.new
  end

  def create
    @voucher = Voucher.new(voucher_params)

    respond_to do |format|
      if @voucher.save
        format.html { redirect_to @voucher, notice: 'Voucher was successfully created.' }
        format.json { render :show, status: :created, location: @voucher }
      else
        format.html { render :new }
        format.json { render json: @voucher.erros, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @voucher.update(voucher_params)
        format.html { redirect_to @voucher, notice: 'Voucher was successfully updated.' }
        format.json { render :show, status: :ok, location: @voucher }
        #
        # @foods = Food.order(:name)
        # ActionCable.server.broadcast 'foods', html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @voucher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @voucher.destroy
    respond_to do |format|
      format.html { redirect_to vouchers_path, notice: 'Voucher was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  def set_voucher
    @voucher = Voucher.find(params[:id])
  end
  def voucher_params
    params.require(:voucher).permit(:code, :valid_from, :valid_through, :amount, :unit, :max_amount)
  end
end
