FactoryBot.define do
	factory :exam do
		title  { Faker::Name.unique.name }
		subject  { Faker::Name.unique.name }
		duration { Faker::Number.number(2) }
    start_date { Faker::Date.between(15.days.ago, 15.days.from_now) }    
	end
end