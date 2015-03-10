class SlackPayload
  def self.prepare(payload)
    message = payload[:text]
    # & replaced with &amp;
    # < replaced with &lt;
    # > replaced with &gt;
    message.gsub!(/[&<>]/, '&' => '&amp;', '<' => '&lt;', '>' => '&gt;')

    room = SlackRoom.find_by(name: payload[:product])
    return {} if room.nil? || !room.publish_to_slack
    channel = room.general_channel

    prepped_payload = {
      text: message,
      channel: channel,
      token: room.token,
      username: payload[:user_handle],
      icon_url: payload[:user_avatar]
    }
  end
end
