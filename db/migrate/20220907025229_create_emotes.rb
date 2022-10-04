class CreateEmotes < ActiveRecord::Migration[6.1]
  def change
    create_table :emotes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.string :emoji

      t.timestamps
    end
  end
end
