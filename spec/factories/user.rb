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
		end

		factory :confirmed_teacher, class: User do
			role "teacher"
		end

		factory :student, class: User do
			role 'student'
			course { Faker::RickAndMorty.character }
			roll_number { 
				[11, 23, 44, 56, 23].sample(1)[0].to_s + "wjsb7015"
			}
			semester { Faker::Number.digit }
		end
	end
end