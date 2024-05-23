if @review.persisted?
  if @review.reviewable.is_a?(Teacher)
    json.form render(partial: "reviews/form", formats: :html, locals: {reviewable: @teacher, review: Review.new})
  elsif @review.reviewable.is_a?(YogaStudio)
    json.form render(partial: "reviews/form", formats: :html, locals: {reviewable: @yoga_studio, review: Review.new})
  end
  json.inserted_item render(partial: "shared/review", formats: :html, locals: {review: @review})
else
  if @review.reviewable.is_a?(Teacher)
    json.form render(partial: "reviews/form", formats: :html, locals: {reviewable: @teacher, review: @review})
  elsif @review.reviewable.is_a?(YogaStudio)
    json.form render(partial: "reviews/form", formats: :html, locals: {reviewable: @yoga_studio, review: @review})
  end
end
