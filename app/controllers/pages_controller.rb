class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @yoga_classes = YogaClass.all
    @random_yoga_classes = @yoga_classes.sample(3)

    @markers = @yoga_classes.map do |yoga_class|
      {
        lat: yoga_class.yoga_studio_teacher.yoga_studio.latitude,
        lng: yoga_class.yoga_studio_teacher.yoga_studio.longitude,
        info_window_html: render_to_string(partial: "shared/info_window", locals: { yoga_class: yoga_class }),
        marker_html: render_to_string(partial: "shared/marker")
      }
    end
  end

  def admin
      @yoga_studios = YogaStudio.where(user: current_user)
      @yoga_classes = YogaClass.where(user: current_user)
      @teachers = Teacher.where(user: current_user)
      @yoga_studio_teacher = YogaStudioTeacher.new
  end
end
