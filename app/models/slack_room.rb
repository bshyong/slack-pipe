class SlackRoom < ActiveRecord::Base
  has_many :message_logs

  def set_general_channel
    
  end
end
