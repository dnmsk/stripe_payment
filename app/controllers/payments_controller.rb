class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  def index
    @payments = Payment.where(user: current_user).all
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # POST /payments
  def create
    @payment = Payment.new(payment_params.merge(attach_user))

    if @payment.save
      begin
        charge = Stripe::Charge.create({
            amount: (@payment.amount * 100).to_i,
            currency: 'usd',
            description: 'Example charge',
            source: @payment.stripe_token,
            metadata: { payment_id: @payment.id }
        })
        store_success charge
        redirect_to @payment, notice: 'Payment was successfully created.'
      rescue => ex
        store_fail_charge ex
        redirect_to :new, notice: ex.to_s, amount: @payment.amount
      end
    else
      render :new
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    redirect_to payments_url, notice: 'Payment was successfully destroyed.'
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find_by(user: current_user, id: params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def payment_params
    params.fetch(:payment).permit(:amount, :stripe_token)
  end

  def attach_user
    {
      user: current_user,
      status: 'new'
    }
  end

  def store_fail_charge exception
    Charge.create(
      user: current_user, 
      status: 'fail',
      data: { exception: exception.to_s },
      payment: @payment
    )
  end

  def store_success charge
    Charge.create(
      user: current_user, 
      status: charge.status,
      data: charge.to_h,
      payment: @payment
    )
  end
end
