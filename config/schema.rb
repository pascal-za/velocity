ActiveRecord::Schema.define(:version => 1) do
  create_table(:foos) do |t|
    t.string :some_string_field
    t.string :another_string_field
    t.integer :some_integer_field
    t.float :some_float_field
    t.text :some_text_field
    t.integer :some_indexed_field
  end
  
  create_table(:bars) do |t|
    t.integer :foo_id
    t.string :a_string_field
  end
  
  add_index :foos, :some_indexed_field
  add_index :bars, :foo_id
end
