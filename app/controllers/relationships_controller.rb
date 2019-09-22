class RelationshipsController < ApplicationController
  before_action :login_required

  def create
    @follow_user = User.find(params[:user_id])
    current_user.follow(@follow_user)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end
end
