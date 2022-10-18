FactoryBot.define do
  factory :emote do
    id {1}
    user_id {1}
    comment_id {1}
    emoji {"check.png"}
  end
end
