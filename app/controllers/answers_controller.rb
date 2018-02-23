class AnswersController < ApplicationController
	def update
    @answer = Answer.find(params[:id])
    @answer.update_attributes(marks: params[:answer][:marks], evaluator: current_user, remarks: params[:answer][:remarks])
    authorize! :update, Answer
	end
end