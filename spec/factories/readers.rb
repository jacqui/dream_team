# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reader do
    first_name "MyString"
    last_name "MyString"
    nyt_id "MyString"
    nyt_username "MyString"
  end
end
