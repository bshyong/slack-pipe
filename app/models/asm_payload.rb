class AsmPayload

  def self.prepare(message_log_id)
    message_log = MessageLog.find(message_log_id)
    slack_room = message_log.slack_room

    payload = {
      message: message_log.attributes,
      user: slack_room.users
                      .where(
                        slack_user_id: message_log.user_id)
                      .first.try(:attributes),
      product: slack_room.name
    }
  end

end