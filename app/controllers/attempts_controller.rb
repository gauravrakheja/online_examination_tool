class AttemptsController < ApplicationController
	before_action :find_exam, only: [:new, :create, :index]

	def new
    	@attempt = @exam.attempts.new
	end

	def create
		@attempt = Attempt.create(user_id: attempt_params[:user_id], exam_id: attempt_params[:exam_id])
		if @attempt.save
			unsaved_answers = submit_answers
			if unsaved_answers.empty?
				flash[:notice] = "Thank you for attempting the Exam"
				redirect_to exams_path
			else
				flash[:alert] = "Some of the answers could not be submitted"
				redirect_back(fallback_location: exams_path)
			end
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

	def submit_answers
		unsaved_answers = []
		@attempt.questions.each_with_index do |question, index|
			question_params = params[:attempt][:questions_attributes][index.to_s]
			if question_params[:answer][:text]
				answer = question.answers.build(attempt: @attempt, text: question_params[:answer][:text])
			else question_params[:answer][:submitted_option]
				answer = question.answers.build(attempt: @attempt, submitted_option: question_params[:answer][:submitted_option])
			end
			unless answer.save
				unsaved_answers << answer
			end
		end
		unsaved_answers
	end

	def attempt_params
		params[:attempt]
	end

	def find_exam
		@exam = Exam.find(params[:exam_id])
	end
end