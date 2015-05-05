require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  def comment_vote_count(id)

		comment_vote_up = CommentVote.where(comment_vote_value: true, comment_id: id).length
		comment_vote_down = CommentVote.where(comment_vote_value: false,comment_id: id).length
		comment_vote_value = (comment_vote_up - comment_vote_down)
		return comment_vote_value
  end

  helper_method :current_user
  helper_method :comment_vote_count
end

