class TeachersController < ApplicationController
	def index
		@teachers = User.unconfirmed_teachers
		authorize! :read, User
	end

	def update
		authorize! :update, User
		@user = User.find(params[:user_id])
		if @user.confirm
			redirect_back(fallback_location: root_path)
			flash[:notice] = "#{@user.name}'s account has been confirmed"
		else
			flash[:alert] = "#{@user.name}'s account could not be verified because #{@user.errors.full_messages}"
			redirect_back(fallback_location: root_path)
		end
	end
end