FactoryBot.define do
	factory :user do
		email { Faker::Internet.email }
		name { Faker::Name.unique.name }
		password { Faker::Internet.password } 

		factory :admin, class: User do
			role "admin"
		end

		factory :teacher, class: User do
			role "teacher"
			confirmed true
		end

		factory :unconfirmed_teacher, class: User do
			role "teacher"
			confirmed nil
		end

		factory :student, class: User do
			role 'student'
			course { AVAILABLE_COURSES.sample }
			roll_number { 
				[11, 23, 44, 56, 23].sample(1)[0].to_s + "wjsb7015"
			}
			semester { Faker::Number.digit }
		end
	end
end