FactoryBot.define do
	factory :question do
		exam
		text { Faker::Company.bs }
		marks { Faker::Number.number(2) }

		factory :objective_question do
			answer_type 'objective'
			correct_option { [1, 2, 3, 4].sample(1)[0] }
			option1 { Faker::Company.bs }
			option2 { Faker::Company.bs }
			option3 { Faker::Company.bs }
			option4 { Faker::Company.bs }
		end

		factory :subjective_question do
			answer_type 'subjective'
		end
	end
end