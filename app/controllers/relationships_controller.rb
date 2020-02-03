class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    follow_user = User.find(params[:user_id])
    current_user.follow(follow_user)
    # フォロー後user情報更新
    @follow_user = User.find(params[:user_id])
    # フォロー通知
    @follow_user.create_notification_follow!(current_user)
    # create.js.erbでrenderされる
  end

  def destroy
    follow_user = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow_user.destroy
    # アンフォロー後user情報更新
    @follow_user = User.find(params[:user_id])
    # destroy.js.erbでrender
  end

  def create_inlist
    follower = User.find(params[:user_id])
    current_user.follow(follower)
    @follower = User.find(params[:user_id])
    # create_inshow.js.erbでrenderされる
  end

  def destroy_inlist
    follow_user = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow_user.destroy
    @follower = User.find(params[:user_id])
    # delete_inshow.js.erbでrenderされる
  end

  def create_inshow
    follower = User.find(params[:user_id])
    current_user.follow(follower)
    @follower = User.find(params[:user_id])
    # create_inshow.js.erbでrenderされる
  end

  def destroy_inshow
    follow_user = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow_user.destroy
    @follower = User.find(params[:user_id])
    # delete_inshow.js.erbでrenderされる
  end
end
