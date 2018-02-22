require 'rails_helper'

describe Exam, type: :model do
	it { should have_many(:attempts) }
	it { should have_many(:questions) }
	it { should have_many(:answers).through(:questions) }

	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:subject) }
	it { should validate_presence_of(:duration) }
	it { should validate_numericality_of(:duration) }
end