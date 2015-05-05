class CommentsController < ApplicationController

	respond_to :html, :js

	def index
	end

	def new
		@comment = Comment.new
	end

	def create
		@comment = Comment.new(comment_params)
		@comment.post_id = params[:post_id]
		@comment.user_id = current_user.id

		@comment.save

		respond_to do |format|
      		format.html 
      		format.js 
    	end

	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def comment_params
		params.require(:comment).permit(:comment_content)
	end
end
