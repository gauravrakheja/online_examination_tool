# == Schema Information
#
# Table name: attempts
#
#  id         :integer          not null, primary key
#  exam_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  aasm_state :string
#

require 'rails_helper'

describe Attempt, type: :model do
  it { should belong_to :user }
  it { should belong_to :exam }
  it { should have_many(:questions).through(:exam) }
  it { should have_many(:answers) }

  it { should delegate_method(:title).to(:exam).with_prefix(true) }
  it { should delegate_method(:subject).to(:exam).with_prefix(true) }
  it { should delegate_method(:duration).to(:exam) }
  it { should delegate_method(:can_give?).to(:exam) }

  it { should accept_nested_attributes_for(:answers) }
  it { should accept_nested_attributes_for(:questions) }

  describe 'without' do
    let(:student) { create(:student) }
    let(:student1) { create(:student) }
    let!(:attempt) { create(:attempt, user: student) }
    let!(:attempt1) { create(:attempt, user: student1) }

    it 'should return the attempts without the given student' do
      expect(Attempt.without(student)).to include attempt1
      expect(Attempt.without(student)).to_not include attempt
    end
  end

  describe 'sum_of_total_marks' do
    let!(:attempt) { create(:attempt) }
    let!(:attempt1) { create(:attempt) }

    before do
      allow_any_instance_of(Attempt).to receive(:total_marks) { 10 }
    end

    it 'should return the sum of total marks' do
      expect(Attempt.sum_of_total_marks).to eq 20
    end
  end

  describe 'sum_of_marks_obtained' do
    let!(:attempt) { create(:attempt) }
    let!(:attempt1) { create(:attempt) }

    before do
      allow(Attempt).to receive(:evaluated).and_return([attempt, attempt1])
      allow_any_instance_of(Attempt).to receive(:marks_obtained) { 5 }
    end

    it 'should return the sum of total marks' do
      expect(Attempt.sum_of_marks_obtained).to eq 10
    end
  end

  describe 'percentage_for_evaluated' do
    let(:evaluated) { double(:evaluated, sum_of_marks_obtained: 80, sum_of_total_marks: 100) }
    before do
      allow(Attempt).to receive(:evaluated) { evaluated }
    end

    it 'should give the percentage of all the attempts evaluated' do
      expect(Attempt.percentage_for_evaluated).to eq 80.00
    end
  end

  describe '#unchecked_answers' do
    let(:answer) { create(:subjective_answer, marks: 10) }
    let(:answer1) { create(:subjective_answer, marks: nil) }
    let(:attempt) { create(:attempt, answers: [answer, answer1]) }

    it 'should only return the unchecked answers' do
      expect(attempt.unchecked_answers).to include answer1
      expect(attempt.unchecked_answers).to_not include answer
    end
  end

  describe '#evaluated' do
    let(:attempt) { build_stubbed(:attempt) }
    
    context 'when the attempt is corrected' do
      before do
        allow(attempt).to receive(:status) { "evaluated" }
      end

      it 'should return true' do
        expect(attempt.evaluated?).to eq true
      end
    end

    context 'when the attempt is not corrected' do
      before do
        allow(attempt).to receive(:status) { "Anything" }
      end

      it 'should return true' do
        expect(attempt.evaluated?).to eq false
      end
    end
  end

  describe '#total_marks' do
    let(:question) { create(:subjective_question) }
    let(:question1) { create(:objective_question) }
    let(:exam) { create(:exam, questions: [question1, question]) }
    let(:attempt) { create(:attempt, exam: exam) }

    it 'should return the sum of the marks of the questions' do
      expect(attempt.total_marks).to eq(question.marks + question1.marks)
    end
  end

  describe '#marks_obtained' do
    let(:answer) { create(:objective_answer, marks: 10) }
    let(:answer1) { create(:subjective_answer, marks: 20) }
    let(:attempt) { create(:attempt, answers: [answer, answer1]) }

    it 'should return the sum of the marks obtained' do
      expect(attempt.marks_obtained).to eq 30
    end
  end

  describe '#end_time' do
    let(:attempt) { build_stubbed(:attempt) }
    let(:stubbed_time) { Time.new('420') }

    before do
      allow(Time).to receive(:now) { stubbed_time }
    end

    it 'should return the duration added to the correct time' do
      expect(attempt.end_time).to eq(stubbed_time+attempt.duration.minutes)
    end
  end

  describe '#marks_percentage' do
    let(:attempt) { build_stubbed(:attempt) }

    before do
      allow(attempt).to receive(:evaluated?) { true }
      allow(attempt).to receive(:total_marks) { 100 }
      allow(attempt).to receive(:marks_obtained) { 10 }
    end

    it 'should give the percentage wth 2 0s' do
      expect(attempt.marks_percentage).to eq 10.00
    end
  end

  describe '#check_if_evaluated' do
    let(:attempt) { create(:attempt) }

    context 'when answers are empty' do
      let(:answers) { double(:answers, empty?: true) }

      before do
        allow(attempt).to receive(:answers) { answers }
      end

      it 'should return nil' do
        expect(attempt.check_if_evaluated).to eq nil
      end
    end

    context 'when already evaluated' do
      before do
        attempt.correct!
      end

      it 'should return nil' do
        expect(attempt.check_if_evaluated).to eq nil
      end
    end

    context 'when unchecked answers empty' do
      let(:answers) { double(:answers, empty?: false, count: 10) }
      let(:questions) { double(:questions, count: 10) }
      let(:unchecked_answers) { double(:unchecked_answers, empty?: true) }
      
      
      before do
        allow(attempt).to receive(:answers) { answers }
        allow(attempt).to receive(:questions) { questions }
        allow(attempt).to receive(:unchecked_answers) { unchecked_answers }
      end

      it 'should correct the attempt' do
        expect(attempt).to receive(:correct!)
        attempt.check_if_evaluated
      end
    end
  end
end
