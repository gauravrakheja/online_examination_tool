class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :attempts

  scope :teachers, -> { where(role: TEACHER_ROLE) }
  scope :students, -> { where(role: STUDENT_ROLE) }

  def teacher?
		role == TEACHER_ROLE
  end

  def student?
  	role == STUDENT_ROLE
  end
end
