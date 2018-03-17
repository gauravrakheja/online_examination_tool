class AttemptsController < ApplicationController
	before_action :find_exam, only: [:new, :create, :index]
	before_action :can_attempt?, only: [:new]

	def new
  	@attempt = @exam.attempts.new
	end

	def create
		@attempt = Attempt.create(user_id: attempt_params[:user_id], exam_id: attempt_params[:exam_id])
		submit_answers
		if @attempt.save
			flash[:notice] = "Thank you for attempting the Exam"
			redirect_to exams_path
		else
			flash[:alert] = "OOPS, looks like something went wrong, please try again!"
			render :new
		end
	end

	def index
		@q = @exam.attempts.ransack(params[:q])
		@attempts = @q.result(distinct: true).order(created_at: :desc)
		authorize! :read, Attempt
	end

	def show
		@attempt = Attempt.find(params[:id])
		authorize! :read, Attempt
	end

	private

	def can_attempt?
		unless @exam.can_give?(current_user)
			flash[:alert] = "You Cannot Give This Exam"
			redirect_to(exams_path) and return
		end
	end

	def submit_answers
		@attempt.questions.each_with_index do |question, index|
			question_params = params[:attempt][:questions_attributes][index.to_s]
			question.answers.create(attempt: @attempt, text: question_params[:answer][:text], submitted_option: question_params[:answer][:submitted_option])
		end
	end

	def attempt_params
		params[:attempt]
	end

	def find_exam
		@exam = Exam.find(params[:exam_id])
	end
end