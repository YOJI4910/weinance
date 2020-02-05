class CommentsController < ApplicationController
  def create
    # Commentモデルにuser_id(current_user), body, record_idを渡してコミット
    comment = current_user.comments.build(comment_params)
    record = comment.record
    if comment.save
      # comment通知
      record.create_notification_comment!(current_user, comment.id)
      # jsonを返す(Ajax)
      render :json => [comment.body, current_user.name]
    else
      render 'records/show'
    end
  end

  def destroy
    comment = Comment.find_by(record_id: params[:record_id], user_id: current_user.id)
    comment.destroy
    redirect_to records_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(params.permit(:record_id))
  end
end
