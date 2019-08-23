class RecordsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @record = Record.new
  end

  def create
    record = Record.new(record_params)
    record.save!
    redirect_to root_url, notice: '体重を記録しました。'
  end

  def edit
  end

  private

  def record_params
    params.require(:record).permit(:weight)
  end
end
