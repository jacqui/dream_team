# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pick do
    reader_id 1
    pick_id 1
    pick_type "MyString"
    date_window "MyString"
  end
end
