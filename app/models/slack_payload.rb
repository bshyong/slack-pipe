class SlackPayload
  def self.prepare(payload)
    message = payload[:text]
    # & replaced with &amp;
    # < replaced with &lt;
    # > replaced with &gt;
    message.gsub!(/[&<>]/, '&' => '&amp;', '<' => '&lt;', '>' => '&gt;')

    chat_room = ChatRoom.find_by(name: payload[:chat_room])

    return {} if chat_room.nil? || !chat_room.slack_room.publish_to_slack

    prepped_payload = {
      text: message,
      channel: chat_room.channel,
      token: chat_room.slack_room.token,
      username: payload[:user_handle],
      icon_url: payload[:user_avatar]
    }
  end
end
