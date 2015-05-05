class CreatePostVotes < ActiveRecord::Migration
  def change
    create_table :post_votes do |t|
    	t.belongs_to :post
    	t.belongs_to :user

    	t.boolean :post_vote_value

      	t.timestamps null: false
    end
  end
end
