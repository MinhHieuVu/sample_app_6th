class EmotesController < ApplicationController
  def show
    comment = Comment.find_by(id: params[:comment_id])
    emote_comment = current_user.emotes.find_or_initialize_by(comment: comment, emoji: params[:emote])
    if emote_comment.new_record?
      emote_comment.save
    else
      emote_comment.destroy
    end
    redirect_to root_path
  end
end
