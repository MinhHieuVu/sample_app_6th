FactoryBot.define do
  factory :user do
    id {1}
    name {"VuMinhHieu"}
    email {"vuminhieu@gmail.com"}
    activate { true }
    password {"password"}
    password_confirmation {"password"}
  end
end
