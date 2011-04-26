require 'faker'

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

puts "Setting up database, this may take a while..."

fake_sentences = []
10.times { fake_sentences << Faker::Lorem.sentence }
paragraphs = Faker::Lorem.paragraphs

Foo.transaction do
  100000.times do
    Foo.create!(:some_string_field => fake_sentences[rand(9)], :another_string_field => fake_sentences[rand(9)], :some_integer_field => rand(9999999), :some_float_field => rand(), :some_text_field => paragraphs, :some_indexed_field => 1)
  end
end

Bar.transaction do
  Foo.select('id').find_each do |foo|
    Bar.create!(:foo_id => foo.id, :a_string_field => fake_sentences[rand(9)])
  end
end
