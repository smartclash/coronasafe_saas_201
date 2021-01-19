require './connect_db'
connect_db!

ActiveRecord::Migration.create_table(:todos) do |t|
  t.string :todo_text, null: false
  t.date :due_date, null: false
  t.boolean :completed, null: false
end
