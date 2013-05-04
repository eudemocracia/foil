require "yaml"
require "active_record"
require "logger"

dbconfig = YAML::load_file "database.yml" 
ActiveRecord::Base.configurations = dbconfig
ActiveRecord::Base.establish_connection "development" 
#ActiveRecord::Base.logger = Logger.new( "log/debug.log" )

ActiveRecord::Schema.define do
  create_table :incoming_mails, :force => true do |t|
    t.string :reverse_path
    t.string :forward_path
    t.string :data
    t.timestamps
  end
end

ActiveRecord::Schema.define do
  create_table :communities, :force => true do |t|
    t.string  :name
    t.string  :domain
    t.integer :supercommunity_id
    t.timestamps
  end
end

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
  create_table :messages, :force => true do |t|
    t.string  :header
    t.string  :content
    #hashtag
    #arrobatag
    t.integer :community_id
    t.integer :space_id
    t.integer :thread_id
    t.integer :sender_id
    t.timestamps
  end
end

ActiveRecord::Schema.define do
  create_table :members, :force => true do |t|
    t.string  :name
    t.string  :mail
    t.integer :phone
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

class Incoming_Mail < ActiveRecord::Base
end

#fixture = YAML::load_file "incoming_mails.yml"
#Incoming_Mail.create fixture["one"]
