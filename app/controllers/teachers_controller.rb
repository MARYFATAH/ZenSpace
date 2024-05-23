class TeachersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  def index
    @teachers = Teacher.all
  end

  def show
    @teacher = Teacher.find(params[:id])
    @review = Review.new
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.user = current_user
    if @teacher.save
      redirect_to teacher_path(@teacher)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set
  end

  def update
    set
    if @teacher.update(teacher_params)
      redirect_to teacher_path(@teacher)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set
    @teacher.destroy
    redirect_to admin_path, status: :see_other
  end

  private

  def set
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    params.require(:teacher).permit(:name, :description, :user, :photo)
  end
end
