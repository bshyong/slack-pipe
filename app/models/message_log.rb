class MessageLog < ActiveRecord::Base
  belongs_to :slack_room
  belongs_to :user
  validates :timestamp, uniqueness: {
    scope: :channel
  }

  after_commit :publish!, on: :create

  def publish!
    # for meta rooms
    if slackroom = SlackRoom.find_by(general_channel: channel, active: true)
      update_column :slack_room_id, slackroom.id
      if msg_subtype.nil? && user_id != 'USLACKBOT' 
        payload = AsmPayload.prepare(id)
        PublishToAsm.perform_async(payload) if slack_room.publish_to_asm
        # TODO: move update published_at into PublishToAsm worker?
        update_column :published_at, Time.now
      end
    end
  end
end
