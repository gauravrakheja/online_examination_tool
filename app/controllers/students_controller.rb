class StudentsController < ApplicationController
	def index
		@students = User.students.all
	end
end