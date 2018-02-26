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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :course, :roll_number, :semester, presence: true, if: :student?
  validates :semester, numericality: true, if: :student?
  validates :email, :name, presence: true
  validate :roll_number_regex, if: :student?

  has_many :attempts
  has_many :messages
  scope :teachers, -> { where(role: TEACHER_ROLE, confirmed: true) }
  scope :unconfirmed_teachers, -> { where(role: TEACHER_ROLE, confirmed: nil) }

  delegate :capitalize, to: :name, prefix: true, allow_nil: true
  delegate :ordinalize, to: :semester, prefix: true, allow_nil: true

  class << self
    def students
      where(role: STUDENT_ROLE)
    end

    def ordered_by_percentage
      all.sort_by { |user| user.percentage_or_zero }
    end
  end

  def percentage_or_zero
    percentage_for_attempts.nil? ? 0 : percentage_for_attempts
  end

  def teacher?
		role == TEACHER_ROLE && confirmed?
  end

  def confirmed?
    confirmed == true
  end

  def confirm
    update_attributes(confirmed: true)
  end

  def admin?
    role == ADMIN_ROLE
  end

  def student?
  	role == STUDENT_ROLE
  end

  def classmates
    User.where(course: course, semester: semester)
  end

  def rank_in_semester
    classmates.ordered_by_percentage.index(self) + 1
  end

  def percentage_for_attempts
    attempts.percentage_for_evaluated
  end

  def marks_with_subjects
    hash = {}
    attempts.evaluated.each_with_index do |attempt, index|
      hash["#{attempt.exam_title}_#{index}"] = attempt.marks_percentage unless attempt.marks_percentage.nil?
    end
    hash
  end

  private

  def roll_number_regex
    flag = roll_number =~ /[0-9][0-9][a-z][a-z][a-z][a-zA-Z0-9][0-9][0-9][0-9][0-9]/
    if flag.nil?
      errors.add(:roll_number, "must be of valid format")
    end
  end
end
