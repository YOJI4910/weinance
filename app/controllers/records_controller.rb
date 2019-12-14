class RecordsController < ApplicationController
  include Pagy::Backend
  include RecordsHelper
  before_action :login_required, only: [:new, :create, :edit, :show]

  def index
    user_ids = Record.all.pluck(:user_id)
    records = get_ordered_records(user_ids)
    @pagy_all, @records = pagy(records, page_param: :page_all, params: { active_tab: 'all' })
    # user_hash = Record.group(:user_id).maximum(:created_at)
    # records = Record.where(user_id: user_hash.keys, created_at: user_hash.values).order(created_at: "DESC")
    # @pagy_all, @records = pagy(records, page_param: :page_all, params: { active_tab: 'all' })

    # current_userのfollowingリスト
    follow_ids = current_user.active_relationships.pluck(:follower_id) if current_user.present?
    if follow_ids.present?
      records = get_ordered_records(follow_ids)
      @pagy_fav, @fav_records = pagy(records, page_param: :page_fav, params: { active_tab: 'favs' })
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
