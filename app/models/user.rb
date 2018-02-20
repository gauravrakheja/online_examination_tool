class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :course, :roll_number, presence: true, if: :student?
  validates :email, :name, presence: true
  validate :roll_number_regex, if: :student?

  has_many :attempts

  scope :teachers, -> { where(role: TEACHER_ROLE, confirmed: true) }
  scope :unconfirmed_teachers, -> { where(role: TEACHER_ROLE, confirmed: nil) }

  class << self
    def students
      where(role: STUDENT_ROLE)
    end
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

  def teacher?
    role == ADMIN_ROLE
  end

  private

  def roll_number_regex
    flag = roll_number =~ /[0-9][0-9][a-z][a-z][a-z][a-zA-Z0-9][0-9][0-9][0-9][0-9]/
    if flag.nil?
      errors.add(:roll_number, "must be of valid format")
    end
  end
end
