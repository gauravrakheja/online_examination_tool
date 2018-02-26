# == Schema Information
#
# Table name: exams
#
#  id         :integer          not null, primary key
#  title      :string
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  duration   :integer
#  start_date :date
#  course     :string
#  semester   :integer
#

require 'rails_helper'

describe Exam, type: :model do
	it { should have_many(:attempts) }
	it { should have_many(:questions) }
	it { should have_many(:answers).through(:questions) }

	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:subject) }
	it { should validate_presence_of(:duration) }
	it { should validate_presence_of(:course) }
	it { should validate_presence_of(:semester) }
	it { should validate_numericality_of(:duration) }
	it { should validate_numericality_of(:semester) }

	describe 'live' do
		let!(:exam) { create(:exam, start_date: Date.today+2.days) }
		let!(:exam1) { create(:exam, start_date: Date.today-1.day) }
		let!(:exam2) { create(:exam, start_date: Date.today) }
	
		it 'should only return the exams with date today or earlier' do
			expect(Exam.live).to include exam1, exam2
			expect(Exam.live).to_not include exam
		end
	end

  describe 'upcoming' do
    let!(:exam) { create(:exam, start_date: Date.today+8.days) }
    let!(:exam1) { create(:exam, start_date: Date.today-1.day) }
    let!(:exam2) { create(:exam, start_date: Date.today) }
    let!(:exam3) { create(:exam, start_date: Date.today+5.days) }
    
    it 'should contain exams from today to upto a week' do
      expect(Exam.upcoming).to include(exam3, exam2)
      expect(Exam.upcoming).to_not include(exam, exam1)
    end
  end

  describe 'for_student' do
    let(:student) { double(:student, course: "BCA", semester: 5) }
    let!(:exam) { create(:exam, course: "BCA", semester: 5) }
    let!(:exam1) { create(:exam, course: "BCA", semester: 2) }
    let!(:exam2) { create(:exam, course: "BBA", semester: 5) }

    it 'should only give the exams with the students semester and course' do
      expect(Exam.for_student(student)).to include exam
      expect(Exam.for_student(student)).to_not include exam1, exam2
    end
  end

  describe '#can_give?' do
    let(:student) { double(:student, course: "BCA", semester: 5) }
    let!(:exam) { create(:exam, course: "BCA", semester: 5) }
    let!(:exam1) { create(:exam, course: "BCA", semester: 2) }

    before do
      allow(exam).to receive(:attempts_dont_contain) { true }
    end

    it 'should only give the exams with the students semester and course' do
      expect(exam.can_give?(student)).to eq true
      expect(exam1.can_give?(student)).to eq false
    end
  end

  describe '#attempts_dont_contain' do
    let(:exam) { build_stubbed(:exam) }
    let(:exam1) { build_stubbed(:exam) }
    let(:student) { double(:student) }
    let(:attempts) { double(:attempts, without: [1]) }
    let(:attempts1) { double(:attempts, without: []) }

    before do
      allow(exam).to receive(:attempts) { attempts }
      allow(exam1).to receive(:attempts) { attempts1 }
    end

    it 'should return the right value' do
      expect(exam.attempts_dont_contain(student)).to eq false
      expect(exam1.attempts_dont_contain(student)).to eq true
    end
  end

	describe '#live' do
    let(:exam) { create(:exam, start_date: Date.today+2.days) }
    let(:exam1) { create(:exam, start_date: Date.today-1.day) }
  	
    it 'should return true for live and false for not live' do
      expect(exam.live?).to eq false
      expect(exam1.live?).to eq true
    end
	end
end
