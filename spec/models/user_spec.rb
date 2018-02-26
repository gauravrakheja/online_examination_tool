# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string
#  course                 :string
#  roll_number            :string
#  name                   :string
#  confirmed              :boolean
#  semester               :integer
#

require 'rails_helper'

describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }

  let(:student) { create(:student) }
  let(:teacher) { create(:teacher) }
  let(:admin) { create(:admin) }
  let(:unconfirmed_teacher) { create(:unconfirmed_teacher) } 

  describe 'roll number regex' do
    let(:user) { build(:student) }

    it 'should allow creation of student with valid roll number' do
      user.roll_number = "something"
      expect(user.save).to eq(false)
      expect(user.errors.full_messages).to include('Roll number must be of valid format')
    end

    it 'should not allow creation of student with invalid roll number' do
      user.roll_number = "15wjsb0264"
      expect(user.save).to eq(true)
    end
  end

  describe 'scopes' do
    it 'should return the correct collection' do
      expect(User.teachers).to include teacher
      expect(User.students).to include student
      expect(User.unconfirmed_teachers).to include unconfirmed_teacher
    end
  end

  describe '#teacher?' do
    it 'should return true for a teacher user' do
      expect(teacher.teacher?).to eq true
      expect(student.teacher?).to eq false
    end
  end

  describe '#confirmed?' do
    it 'should return true for confirmed user' do
      expect(teacher.confirmed?).to eq true
      expect(unconfirmed_teacher.confirmed?).to eq false
    end
  end

  describe '#percentage_or_zero' do
    let(:user) { build_stubbed(:student) }

    context 'when percentage for attempts exists' do
      before do
        allow(user).to receive(:percentage_for_attempts) { "something" }
      end

      it 'should return the value' do
        expect(user.percentage_or_zero).to eq("something")
      end
    end

    context 'when percentage for attempts do not exist' do
      before do
        allow(user).to receive(:percentage_for_attempts) { nil }
      end

      it 'should return 0' do
        expect(user.percentage_or_zero).to eq 0
      end
    end
  end

  describe '#classmates' do
    let!(:student) { create(:student, course: "BCA", semester: 2) }
    let!(:student1) { create(:student, course: "BCA", semester: 2) }
    let!(:student2) { create(:student, course: "BBA", semester: 2) }
    let!(:student3) { create(:student, course: "BCA", semester: 4) }
  
    it 'should only return the calssmates' do
      expect(student.classmates).to include student1, student
      expect(student.classmates).to_not include student3, student2
    end
  end

  describe '#rank_in_semester' do
    let!(:student) { build_stubbed(:student) }
    let(:ordered) { double(:ordered, index: 2) }
    let(:classmates) { double(:classmates, ordered_by_percentage: ordered) }
    
    before do
      allow(student).to receive(:classmates).and_return(classmates)
    end

    it 'should return the rank' do
      expect(student.rank_in_semester).to eq 3
    end
  end

  describe '#percentage_for_attempts' do
    let(:student) { build_stubbed(:student) }
    let(:attempts) { double(:attempts, percentage_for_evaluated: 18.0 ) }

    before do
      allow(student).to receive(:attempts).and_return(attempts)
    end

    it 'should return the percentage from the attemtps' do
      expect(student.percentage_for_attempts).to eq 18.0
    end
  end

  describe '#confirm' do
    it 'should confirm the user' do
      expect(student.confirmed?).to eq false
      student.confirm
      expect(student.confirmed?).to eq true
    end
  end

  describe '#admin?' do
    it 'should return true for admin user'do
      expect(teacher.admin?).to eq false
      expect(admin.admin?).to eq true
    end
  end

  describe '#student?' do
    it 'should return true for student user' do
      expect(teacher.student?).to eq false
      expect(student.student?).to eq true
    end
  end
end
