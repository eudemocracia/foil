class Subscription < ActiveRecord::Base
  belongs_to :space
  belongs_to :subscriptor, class_name: 'Member'
end
