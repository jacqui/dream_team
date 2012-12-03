# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pick_bucket do
    pick_type "MyString"
    pick_window_id 1
    count 1
    required false
  end
end
