# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  exam_id        :integer
#  text           :string
#  marks          :integer
#  answer_type    :string
#  option1        :string
#  option2        :string
#  option3        :string
#  option4        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  correct_option :integer
#

require 'rails_helper'

describe Question, type: :model do
	it { should belong_to :exam }
	it { should have_many :answers }
	it { should have_many(:attempts).through(:exam) }

	it { should validate_presence_of(:text) }
	it { should validate_presence_of(:marks) }
	it { should validate_presence_of(:answer_type) }
	it { should validate_numericality_of(:marks) }

	it { should accept_nested_attributes_for(:answers) }

	describe '#objective' do
		let(:question) { create(:objective_question) }
		let(:question1) { create(:subjective_question) }

		it 'should return the true for objective and false otherwise' do
			expect(question.objective?).to eq true
			expect(question1.objective?).to eq false
		end
	end

	describe '#subjective' do
		let(:question1) { create(:objective_question) }
		let(:question) { create(:subjective_question) }

		it 'should return the true for objective and false otherwise' do
			expect(question.subjective?).to eq true
			expect(question1.subjective?).to eq false
		end
	end

	describe '#answer_for_attempt' do
		let(:attempt) { create(:attempt) }
		let(:exam) { create(:exam, attempts: [attempt]) }
		let(:question) { create(:subjective_question, exam: exam) }
		let!(:answer) { create(:subjective_answer, question: question, attempt: attempt) }
		let!(:answer1) { create(:subjective_answer, question: question) }

		it 'should return only the answer for the attempt asked' do
			expect(question.answer_for_attempt(attempt)).to eq answer
		end
	end
end
