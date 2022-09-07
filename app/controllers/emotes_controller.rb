class EmotesController < ApplicationController
  def show
    comment = Comment.find_by(id: params[:comment_id])
    emote = current_user.emotes.find_or_initialize_by(comment: comment, emoji: params[:emote])
    if emote.new_record?
      emote.save
    else
      emote.destroy
    end
    redirect_to root_path
  end
end
