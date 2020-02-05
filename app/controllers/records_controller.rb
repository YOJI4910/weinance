class RecordsController < ApplicationController
  include Pagy::Backend
  include RecordsHelper

  before_action :authenticate_user!, except: :index

  def index
    user_ids = Record.all.pluck(:user_id)
    records = get_ordered_records(user_ids)
    @pagy_all, @records = pagy(records, page_param: :page_all, params: { active_tab: 'all' })
    # current_userのfollowingリスト
    follow_ids = current_user.active_relationships.pluck(:follower_id) if current_user.present?
    if follow_ids.present?
      records = get_ordered_records(follow_ids)
      @pagy_fav, @fav_records = pagy(records, page_param: :page_fav, params: { active_tab: 'favs' })
    end
  end

  def show
    @record = Record.find(params[:id])
    @user = @record.user
    @records = @user.records
    @comments = @record.comments.order(id: "DESC")
    @comment = Comment.new
  end

  def new
    @record = Record.new
  end

  def create
    @record = current_user.records.new(record_params)
    if @record.save
      redirect_to root_url, notice: '体重を記録しました。'
    else
      render :new
    end
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    @record = Record.find(params[:id])
    if @record.update(record_params)
      redirect_to user_path(@record.user), notice: '体重記録を修正しました'
    else
      render :edit
    end
  end

  def destroy
    Record.find(params[:id]).destroy
    redirect_to current_user, notice: 'レコードを削除しました'
  end

  private

  def record_params
    params.require(:record).permit(:weight)
  end
end
