FactoryBot.define do
	factory :answer do
		attempt
		association :evaluator, factory: :teacher
		exam
		question
		
		factory :objective_answer do
			association :question, factory: :objective_question
			submitted_option { [1, 2, 3, 4].sample(1).first }
		end

		factory :subjective_answer do
			association :question, factory: :subjective_question
			text { Faker::Company.bs }
		end
	end
end