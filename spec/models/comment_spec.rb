require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:micropost) {FactoryBot.create(:micropost)}
  let(:comment) {FactoryBot.create(:comment)}
  let(:emote) {FactoryBot.create(:emote)}
  describe "emotes_size" do
      it { is_expected.to run.with_params("check.png").and_return(1) }
  end
end
