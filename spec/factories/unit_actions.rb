# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unit_action do
    points 1
    qualifying_metric_type "MyString"
    qualifying_metric_amount 1
    qualifying_position "MyString"
  end
end
