require 'rails_helper'

describe Answer, type: :model do
	it { should belong_to :question }
	it { should belong_to :attempt }
	it { should belong_to(:evaluator).class_name('User').with_foreign_key('user_id') }
	it { should have_one :exam }

	it { is_expected.to callback(:correct_answer).after(:save).if(:objective?) }
	it { is_expected.to callback(:update_attempt).after(:save) }

	describe  'checked' do
		let(:answer1) { create(:subjective_answer, marks: nil) }
		let(:answer2) { create(:objective_answer) }
		let(:answer3) { create(:objective_answer, marks: 29) }

		it 'should give all the checked answers' do
			expect(Answer.checked).to include(answer3, answer2)
			expect(Answer.checked).to_not include(answer1)
		end
	end

	describe '#submitted_answer' do
		let(:answer1) { create(:objective_answer) }
		let(:answer2) { create(:subjective_answer) }

		it 'should give the correct option for the correct answer type' do
			expect(answer1.submitted_answer).to eq(answer1.submitted_option)
			expect(answer2.submitted_answer).to eq(answer2.text)
		end
	end

	describe '#checked?' do
		let(:answer) { build_stubbed(:answer) }

		context 'when marks present' do
			let(:marks) { double(:marks, present?: true) }

			before do
				allow(answer).to receive(:marks).and_return(marks)
			end

			it 'should return true' do
				expect(answer.checked?).to eq true
			end
		end

		context 'when marks are not present' do
			let(:marks) { double(:marks, present?: false) }

			before do
				allow(answer).to receive(:marks).and_return(marks)
			end
			
			it 'should return false' do
				expect(answer.checked?).to eq false
			end
		end
	end

	describe '#evaluated_by' do
		let(:answer) { build_stubbed(:answer, marks: 10) }

		context 'when evaluator present' do
			let(:evaluator) { double(:evaluator, name: "test") }

			before do
				allow(answer).to receive(:evaluator) { evaluator }
			end

			it 'should return the name of the evaluator' do
				expect(answer.evaluated_by).to eq(evaluator.name)
			end
		end

		context 'when evaluator not present and marks present' do
			let(:marks) { double(:marks, nil?: false) }

			before do
				allow(answer).to receive(:evaluator) { nil }
				allow(answer).to receive(:marks) { marks }
			end

			it 'should return auto' do
				expect(answer.evaluated_by).to eq("auto")
			end
		end

		context 'when evaluator and marks not present' do
			let(:marks) { double(:marks, nil?: true) }

			before do
				allow(answer).to receive(:evaluator) { nil }
				allow(answer).to receive(:marks) { marks }
			end

			it 'should return nil' do
				expect(answer.evaluated_by).to eq(nil)
			end
		end
	end
end