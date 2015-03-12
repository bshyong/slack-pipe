class SlackRoom < ActiveRecord::Base
  has_many :message_logs
  has_many :users
  has_many :slack_channels
  has_many :chat_rooms

  after_commit :initialize_room, on: :create

  def initialize_room
    Slack::InitializeRoom.perform_async(id)
  end
end
