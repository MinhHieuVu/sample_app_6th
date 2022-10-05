FactoryBot.define do
  factory :comment do
    id {1}
    user_id {1}
    micropost_id {1}
    body {"example comment reference user id 1 vs micropost id 1"}
  end
end
