# == Schema Information
#
# Table name: rooms
#
#  id            :integer          not null, primary key
#  title         :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  subject       :string
#  teachers_only :boolean
#

FactoryBot.define do
  factory :room do
    title "MyString"
    name "MyString"
    user nil
  end
end
