class PagesController < ApplicationController
	def home
    @upcoming_exams = current_user.upcoming_exams
	end
end