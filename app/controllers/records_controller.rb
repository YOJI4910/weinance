class RecordsController < ApplicationController
  before_action :login_required

  def index
    @tasks = current_user.records
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
