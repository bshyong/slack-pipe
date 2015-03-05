class MessageLog < ActiveRecord::Base
  belongs_to :slack_room

  validates :timestamp, uniqueness: { scope: :channel,
    message: "timestamp should be unique per channel" }

  after_commit :publish!

  def publish!
    if channel == slack_room.general_channel
      puts "trying to publish"
      # publish this message
    end
  end
end
