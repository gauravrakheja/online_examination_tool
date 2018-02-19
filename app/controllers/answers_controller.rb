class AnswersController < ApplicationController
	def update
		@answer = Answer.find(params[:id])
		@answer.update_attributes(marks: params[:answer][:marks], evaluator: current_user)
	end
end