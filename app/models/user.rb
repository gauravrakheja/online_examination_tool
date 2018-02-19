class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :course, :roll_number, presence: true, if: :student?

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
end
