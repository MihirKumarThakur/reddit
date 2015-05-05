class PostsController < ApplicationController
	
	respond_to :html, :js

	def index
		@posts = Post.where(user_id: current_user.id).to_a
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id 
		@post.save

		# @post.save
		#render '/users/index'
		

		# redirect_to '/posts'
	end

	def show
		@post = Post.find(params[:id])
		@comments = @post.comments.to_a
		@post_vote_value = post_vote_count(params[:id])

		if current_user 
			vote_value = PostVote.where(user_id: current_user.id, post_id: params[:id])[0]
		end
		
		if vote_value
			@vote_value = vote_value.post_vote_value
		end

	end


	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])

		if @post.update(post_params)
			respond_to do |format|
				format.html { redirect_to @post }
				format.js 
			end
		else
			render 'edit'
		end
	end


	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		@posts = Post.where(user_id: current_user.id).to_a
		respond_to do |format|
			format.html { redirect_to users_path }
			format.js 
		end
	end

	def commentvote
		



		if (CommentVote.where(user_id: current_user.id, comment_id: params[:comment_id].to_i).length > 0)
			@commentvote = CommentVote.where(comment_id: params[:comment_id], user_id: current_user.id).first

			# if vote up and vote down will clicked again  and again value of that will be deleted

			if @commentvote.comment_vote_value.to_s == params[:comment_vote_value]
				@commentvote.destroy
			else 
				@commentvote.update(comment_vote_value: params[:comment_vote_value])
			end


		else
			CommentVote.create(comment_id: params[:comment_id].to_i, user_id: current_user.id, comment_vote_value: params[:comment_vote_value])
		end

		# update the link for vote up and down using vote value

		@comment_vote_value = comment_vote_count(params[:comment_id].to_i)
		p " in comment votes 5555555555555555555555555555555555555555555555555555555"
		p @comment_vote_value
		if request.xhr?
			render json: { comment_vote_value: @comment_vote_value }
		end

	end


	
	# def comment_vote_count(id)

	# 	comment_vote_up = CommentVote.where(comment_vote_value: true, comment_id: id).length
	# 	comment_vote_down = CommentVote.where(comment_vote_value: false,comment_id: id).length
	# 	comment_vote_value = (comment_vote_up - comment_vote_down)
	# 	return comment_vote_value
	# end
	



	def postvote
		
		#find if user has already commeted on that post updte that value don't create a new one.

		if (PostVote.where(user_id: current_user.id, post_id: params[:post_id]).length > 0)
			@postvote = PostVote.where(post_id: params[:post_id], user_id: current_user.id).first

			# if vote up and vote down will clicked again  and again value of that will be deleted

			if @postvote.post_vote_value.to_s == params[:post_vote_value]
				@postvote.destroy
			else 
				@postvote.update(post_vote_value: params[:post_vote_value])
			end


		else
			PostVote.create(post_id: params[:post_id], user_id: current_user.id, post_vote_value: params[:post_vote_value])
		end

		# update the link for vote up and down using vote value

		@post_vote_value = post_vote_count(params[:post_id])
		
		if request.xhr?
			render json: { post_vote_value: @post_vote_value }
		end
	end




	def post_vote_count(id)

		post_vote_up = PostVote.where(post_vote_value: true, post_id: id).length
		post_vote_down = PostVote.where(post_vote_value: false,post_id: id).length
		post_vote_value = (post_vote_up - post_vote_down)
		return post_vote_value
	end


	private

	def post_params
		params.require(:post).permit(:title, :content)
	end
end
