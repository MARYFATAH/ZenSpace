class YogaClassesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @yoga_studios = YogaStudio.all
    @yoga_classes = YogaClass.all.where("start_time > ?", DateTime.now).order(start_time: :asc)
    # Search bar
    if params[:query].present?
      @yoga_classes = YogaClass.global_search(params[:query])
    else
      @yoga_classes = YogaClass.all
    end

    # Style filter
    if params[:style].present?
      if @yoga_classes.respond_to?(:where)
        @yoga_classes = @yoga_classes.where(style: params[:style])
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.style == params[:style] }
      end
      @yoga_classes = [] unless @yoga_classes.present?
    end

    # Difficulty filter
    if params[:difficulty].present?
      if @yoga_classes.respond_to?(:where)
        @yoga_classes = @yoga_classes.where(difficulty: params[:difficulty])
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.difficulty == params[:difficulty] }
      end
      @yoga_classes = [] unless @yoga_classes.present?
    end

    # Duration filter
    if params[:duration_min].present? && params[:duration_max].present?
      if @yoga_classes.respond_to?(:select)
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.duration_in_minutes.between?(params[:duration_min].to_i, params[:duration_max].to_i) }
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.duration_in_minutes.between?(params[:duration_min].to_i, params[:duration_max].to_i) } unless @yoga_classes.nil?
      end
    end

    # Price filter
    if params[:price_min].present? && params[:price_max].present?
      if @yoga_classes.respond_to?(:where)
        @yoga_classes = @yoga_classes.where(price: params[:price_min].to_f..params[:price_max].to_f)
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.price.between?(params[:price_min].to_f, params[:price_max].to_f) } unless @yoga_classes.nil?
      end
    end

    # Distance filter
    if params[:address].present? && params[:max_distance].present?
      if @yoga_classes.respond_to?(:near)
        # Geocode the user's input address to get the latitude and longitude
        results = Geocoder.search(params[:address])
        if results.present?
          latitude = results.first.latitude
          longitude = results.first.longitude
          # Find yoga classes within the max distance from the user's input address
          @yoga_classes = YogaStudio.geocoded.near([latitude, longitude], params[:max_distance]).map(&:yoga_classes).flatten.uniq
        end
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.yoga_studio.distance_to(params[:address]) <= params[:max_distance].to_f } unless @yoga_classes.nil?
      end
    end

    # Time filter
    if params[:start_date].present? && params[:end_date].present?
      if @yoga_classes.respond_to?(:where)
        start_time = DateTime.parse(params[:start_date])
        end_time = DateTime.parse(params[:end_date])
        @yoga_classes = @yoga_classes.where(start_time: start_time..end_time)
      else
        @yoga_classes = @yoga_classes.select { |yoga_class| yoga_class.start_time.between?(params[:start_date], params[:end_date]) } unless @yoga_classes.nil?
      end
    end

    # Map markers
    @markers = @yoga_classes.map do |yoga_class|
      {
        lat: yoga_class.yoga_studio_teacher.yoga_studio.latitude,
        lng: yoga_class.yoga_studio_teacher.yoga_studio.longitude,
        info_window_html: render_to_string(partial: "shared/info_window", locals: { yoga_class: yoga_class }),
        marker_html: render_to_string(partial: "shared/marker")
      }
    end
  end

  def show
    @yoga_class = YogaClass.find(params[:id])
    @booking = Booking.new(yoga_class: @yoga_class)
    @yoga_classes = [@yoga_class]
    @markers = @yoga_classes.map do |yoga_class|
      {
        lat: yoga_class.yoga_studio_teacher.yoga_studio.latitude,
        lng: yoga_class.yoga_studio_teacher.yoga_studio.longitude,
        info_window_html: render_to_string(partial: "shared/show_window", locals: { yoga_studio: yoga_class.yoga_studio_teacher.yoga_studio }),
        marker_html: render_to_string(partial: "shared/marker")
      }
    end
  end

  def new
    @yoga_class = YogaClass.new
  end

  def create
    @yoga_class = YogaClass.new(yoga_class_params)
    @yoga_class.user = current_user
    @yoga_studio_teacher = YogaStudioTeacher.create!(yoga_studio_id: params[:yoga_class][:yoga_studio].to_i, teacher_id: params[:yoga_class][:teacher].to_i)
    @yoga_class.yoga_studio_teacher = @yoga_studio_teacher
    if @yoga_class.save
      redirect_to yoga_classes_path, notice: "Yoga class was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set
  end

  def update
    set
    @yoga_class.update(yoga_class_params)
    redirect_to yoga_class_path(@yoga_class)
  end

  def destroy
    set
    @yoga_class.destroy
    redirect_to admin_path, status: :see_other
  end

  private

  def set
    @yoga_class = YogaClass.find(params[:id])
  end

  def yoga_class_params
    params.require(:yoga_class).permit(:name, :price, :description, :difficulty, :style, :start_time, :end_time, :capacity, :photo, :yoga_studio, :teacher)
  end
end
