FactoryGirl.define do
  factory :ticker do
    
  end

  factory :user do
    username "testuser"
    email  "test@test.com"
    password "123456"
    password_confirmation "123456"
  end

end