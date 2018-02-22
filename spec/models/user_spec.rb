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