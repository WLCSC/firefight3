class Use < ActiveRecord::Base
  belongs_to :room
  belongs_to :consumable
  
end
