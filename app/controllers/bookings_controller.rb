class BookingsController < ApplicationController
  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @yoga_class = YogaClass.find(params[:yoga_class_id])
    @booking.yoga_class = @yoga_class
    if @booking.save
      redirect_to yoga_class_booking_path(@yoga_class, @booking)
    else
      redirect_to yoga_class_path(@booking.yoga_class)
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @user = @booking.user
  end

  def confirmation
    @booking = Booking.find(params[:id])
    @yoga_classes = [@booking.yoga_class]
    @markers = @yoga_classes.map do |yoga_class|
      {
        lat: yoga_class.yoga_studio_teacher.yoga_studio.latitude,
        lng: yoga_class.yoga_studio_teacher.yoga_studio.longitude,
        info_window_html: render_to_string(partial: "shared/show_window", locals: { yoga_studio: yoga_class.yoga_studio_teacher.yoga_studio }),
        marker_html: render_to_string(partial: "shared/marker")
      }
    end
  end

  def index

    @bookings = Booking.joins(:yoga_class)
                       .where(user: current_user)
                       .where("yoga_classes.start_time > ?", DateTime.now)
                       .order("yoga_classes.start_time ASC")
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path, status: :see_other
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :yoga_class_id)
  end
end
