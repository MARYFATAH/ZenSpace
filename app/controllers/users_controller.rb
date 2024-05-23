class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])
    @booking = Booking.find(params[:booking_id])
    if @user.update(user_params)
      redirect_to confirmation_path(@booking)
    else
      render "bookings/show", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :company, :address, :phone, :card_name, :card_number, :card_cvv, :card_expiration)
  end
end
