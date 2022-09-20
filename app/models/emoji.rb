class Emoji
  include EmotesHelper

  def self.all_emoji
    self.new.all_emoji
  end

  def all_emoji
    list_of_emojis
  end

end