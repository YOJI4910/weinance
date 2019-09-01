class StaticPagesController < ApplicationController
  def about
    @users = User.all
    @records = Record.all
  end
end
