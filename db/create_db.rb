

ActiveRecord::Schema.define do
  create_table :spaces, :force => true do |t|
    t.string  :name
    t.string  :path
    t.integer :community_id
    t.integer :superspace_id
    t.timestamps
  end
end

ActiveRecord::Schema.define do
  create_table :topics, :force => true do |t|
    t.string  :title
    t.integer :space_id
    t.integer :superthread_id
    t.timestamps
  end
end



ActiveRecord::Schema.define do
  create_table :suscriptions, :force => true do |t|
    t.integer :space_id
    t.integer :suscriptor_id
    t.timestamps
  end
end

