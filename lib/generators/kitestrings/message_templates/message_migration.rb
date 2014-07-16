class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user
      t.string :template
      t.string :context_type
      t.integer :context_id
      t.string :link
      t.string :subject
      t.datetime :clicked_at
      t.datetime :sent_at
      t.text :options

      t.timestamps
    end

    add_index :messages, :user_id
    add_index :messages, [:context_type, :context_id]
  end
end
