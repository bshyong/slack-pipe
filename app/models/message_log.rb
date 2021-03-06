class MessageLog < ActiveRecord::Base
  belongs_to :slack_room
  belongs_to :slack_channel
  belongs_to :chat_room
  belongs_to :user
  validates :timestamp, uniqueness: {
    scope: :channel
  }

  after_commit :publish!, on: :create

  def publish!
    if msg_subtype.nil? && user_id != 'USLACKBOT'
      payload = AsmPayload.prepare(id)
      PublishToAsm.perform_async(payload) if slack_room.publish_to_asm
      # TODO: move update published_at into PublishToAsm worker?
      update_column :published_at, Time.now
    end
  end
end
