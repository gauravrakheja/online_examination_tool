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

class Room < ApplicationRecord
  has_many :messages

  class << self
    def teachers_only
      where.(teacher_only: true)
    end

    def for_user(user)
      user.teacher? ? teachers_only : all 
    end
  end
end
