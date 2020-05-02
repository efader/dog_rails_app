class AddTimestampsToLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :likes, :created_at, :datetime
  end
end
