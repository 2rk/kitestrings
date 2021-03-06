require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :record do |t|
  t.string :name
  t.integer :genre_id
  t.timestamps
end

class Record < ActiveRecord::Base
end
