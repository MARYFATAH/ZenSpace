class ReviewsController < ApplicationController
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    if @review.reviewable.is_a?(Teacher)
      redirect_to teacher_path(@review.reviewable)
    elsif @review.reviewable.is_a?(YogaStudio)
      redirect_to yoga_studio_path(@review.reviewable)
    end
  end

  def create
    @review = Review.new(review_params)
    if params[:teacher_id].present?
      @teacher = Teacher.find(params[:teacher_id])
      @review.reviewable = Teacher.find(params[:teacher_id])
    elsif params[:yoga_studio_id].present?
      @yoga_studio = YogaStudio.find(params[:yoga_studio_id])
      @review.reviewable = YogaStudio.find(params[:yoga_studio_id])
    else
      # handle error: unknown reviewable type
    end

    respond_to do |format|
      if @review.save
        if @review.reviewable.is_a?(Teacher)
          # redirect_to teacher_path(@review.reviewable)
          format.html { redirect_to teacher_path(@review.reviewable) }
          format.json # Follow the classic Rails flow and look for a create.json view
        elsif @review.reviewable.is_a?(YogaStudio)
          # redirect_to yoga_studio_path(@review.reviewable)
          format.html { redirect_to yoga_studio_path(@review.reviewable) }
          format.json # Follow the classic Rails flow and look for a create.json view
        end
      else
        # redirect_to root_path
        format.html { redirect_to yoga_classes_path, status: :unprocessable_entity }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
