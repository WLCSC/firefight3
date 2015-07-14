class Step < ActiveRecord::Base
  belongs_to :ticket

  def done?
    status == 1
  end
end
