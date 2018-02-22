FactoryBot.define do
	factory :exam do
		title  { Faker::Name.unique.name }
		subject  { Faker::Name.unique.name }
		duration { Faker::Number.number(2) }
	end
end