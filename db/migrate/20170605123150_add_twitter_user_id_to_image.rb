class AddTwitterUserIdToImage < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :twitter_user_id, :bigint
  end
end
