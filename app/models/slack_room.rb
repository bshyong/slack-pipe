class SlackRoom < ActiveRecord::Base
  has_many :message_logs
end
