class YogaStudioTeachersController < ApplicationController
  def create
    @yoga_studio_teacher = YogaStudioTeacher.new(yoga_studio_teacher_params)
    if @yoga_studio_teacher.save
      redirect_to yoga_studio_path(@yoga_studio_teacher.yoga_studio)
    else
      raise
    end
  end

  private

  def yoga_studio_teacher_params
    params.require(:yoga_studio_teacher).permit(:yoga_studio_id, :teacher_id)
  end
end
