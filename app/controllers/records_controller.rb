class RecordsController < ApplicationController
  include Pagy::Backend
  before_action :login_required, only: [:new, :create, :edit, :show]

  def index
    user_hash = Record.group(:user_id).maximum(:created_at)
    records = Record.where(user_id: user_hash.keys, created_at: user_hash.values).order(created_at: "DESC")
    @pagy_all, @records = pagy(records, page_param: :page_all, params: { active_tab: 'all' })

    # ======================favo用
    # current_userのfollowingリスト
    follow_list = current_user.active_relationships.pluck(:follower_id) if current_user.present?
    if follow_list.present?
      favo_hash = Record.where(user_id: follow_list).group(:user_id).maximum(:created_at)
      records = Record.where(user_id: favo_hash.keys, created_at: favo_hash.values).order(created_at: "DESC")
      @pagy_fav, @favos = pagy(records, page_param: :page_fav, params: { active_tab: 'favs' })
    end
  end

  def show
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
  end

  private

  def record_params
    params.require(:record).permit(:weight)
  end
end
