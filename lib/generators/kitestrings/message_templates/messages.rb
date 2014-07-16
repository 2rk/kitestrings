# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    link "/"
    # clicked_at nil
    # sent_at nil
    template "default"
    # options nil
  end
end
