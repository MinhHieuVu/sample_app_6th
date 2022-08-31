class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :micropost, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :parent_id, null: true
      t.timestamps
    end
  end
end