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
      let(:answers) { double(:answers, empty?: false) }
      let(:unchecked_answers) { double(:unchecked_answers, empty?: true) }
      
      
      before do
        allow(attempt).to receive(:answers) { answers }
        allow(attempt).to receive(:unchecked_answers) { unchecked_answers }
      end

      it 'should correct the attempt' do
        expect(attempt).to receive(:correct!)
        attempt.check_if_evaluated
      end
    end
  end
end