class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow_user = User.find(params[:user_id])
    current_user.follow(follow_user)
    # フォロー後user情報更新
    @follow_user = User.find(params[:user_id])
    # create.js.erbでrenderされる
  end

  def destroy
    follow_user = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow_user.destroy
    # アンフォロー後user情報更新
    @follow_user = User.find(params[:user_id])
    # destroy.js.erbでrender
  end
end
