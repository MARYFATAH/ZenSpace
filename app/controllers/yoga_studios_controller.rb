class YogaStudiosController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def show
    @yoga_studio = YogaStudio.find(params[:id])
    @review = Review.new

    # Map markers
    @yoga_studios = [@yoga_studio]
    @markers = @yoga_studios.map do |yoga_studio|
      {
        lat: yoga_studio.latitude,
        lng: yoga_studio.longitude,
        info_window_html: render_to_string(partial: "shared/show_window", locals: { yoga_studio: yoga_studio }),
        marker_html: render_to_string(partial: "shared/marker")
      }
    end
  end

  def index
    @yoga_studios = YogaStudio.all
  end

  def new
    @yoga_studio = YogaStudio.new
  end

  def create
    @yoga_studio = YogaStudio.new(studio_params)
    @yoga_studio.user = current_user
    if @yoga_studio.save
      redirect_to yoga_studio_path(@yoga_studio)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set
  end

  def update
    set
    if @yoga_studio.update(studio_params)
      redirect_to yoga_studio_path(@yoga_studio)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set
    @yoga_studio.destroy
    redirect_to admin_path, status: :see_other
  end

  private

  def set
    @yoga_studio = YogaStudio.find(params[:id])
  end

  def studio_params
    params.require(:yoga_studio).permit(:name, :address, :description, photos: [])
  end
end
