require "yaml"
require "active_record"

dbconfig = YAML::load_file "database.yml" 
ActiveRecord::Base.configurations = dbconfig
ActiveRecord::Base.establish_connection "development" 

ActiveRecord::Schema.define do
  create_table :mails, :force => true do |t|
    t.string :reverse_path
    t.string :forward_path
    t.string :data
    t.timestamps
  end
end
