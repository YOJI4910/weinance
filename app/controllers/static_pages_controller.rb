class StaticPagesController < ApplicationController
  def about
    @users = User.all
    @records = Record.all
  end

  def privacy
  end
end
