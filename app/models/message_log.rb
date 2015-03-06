class MessageLog < ActiveRecord::Base
  belongs_to :slack_room
  belongs_to :user

  after_commit :publish!, on: :create

  def publish!
    if channel == 'C03TTCR5P'#slack_room.general_channel
      payload = AsmPayload.prepare(id)
      PublishToAsm.perform_async(payload)
    end
  end
end
