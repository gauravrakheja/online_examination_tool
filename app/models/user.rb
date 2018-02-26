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

  private

  def roll_number_regex
    flag = roll_number =~ /[0-9][0-9][a-z][a-z][a-z][a-zA-Z0-9][0-9][0-9][0-9][0-9]/
    if flag.nil?
      errors.add(:roll_number, "must be of valid format")
    end
  end
end
