class StudentsController < ApplicationController
	def index
		@q = User.students.ransack(params[:q])
		@students = @q.result(distict: true)
	end
end