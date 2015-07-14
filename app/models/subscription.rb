class Subscription < ActiveRecord::Base
  belongs_to :subscribable, polymorphic: true
end
