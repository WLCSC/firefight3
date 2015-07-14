class Consumer < ActiveRecord::Base
  belongs_to :model
  belongs_to :consumable
end
