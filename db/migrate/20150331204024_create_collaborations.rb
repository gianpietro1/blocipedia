class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.integer :user_id
      t.integer :wiki_id

      t.timestamps null: false
    end
    add_index :collaborations, :user_id
    add_index :collaborations, :wiki_id
  end
end
