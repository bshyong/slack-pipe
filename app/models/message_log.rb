class MessageLog < ActiveRecord::Base
  belongs_to :slack_room
  belongs_to :user
  validates :timestamp, uniqueness: {
    scope: :channel
  }

  after_commit :publish!, on: :create

  def publish!
    if channel == 'C03TTCR5P'#slack_room.general_channel
      payload = AsmPayload.prepare(id)
      PublishToAsm.perform_async(payload)
      update_column :published_at, Time.now
    end
  end
end
