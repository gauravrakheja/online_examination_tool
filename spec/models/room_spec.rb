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

require 'rails_helper'

RSpec.describe Room, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
