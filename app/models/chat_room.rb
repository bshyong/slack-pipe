class ChatRoom < ActiveRecord::Base
  belongs_to :slack_room

  validates :channel, uniqueness: {
    scope: :slack_room_id
  }
end
