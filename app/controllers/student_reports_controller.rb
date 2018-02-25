class StudentReportsController < ApplicationController
  def show
    @student = User.find(params[:user_id])
  end
end