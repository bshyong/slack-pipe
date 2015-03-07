class SlackPayload
  def self.prepare(payload)
    message = payload[:text]
    # & replaced with &amp;
    # < replaced with &lt;
    # > replaced with &gt;
    message.gsub!(/[&<>]/, '&' => '&amp;', '<' => '&lt;', '>' => '&gt;')

    prepped_payload = {
      text: message,
      channel: "C03TTCR5P",
      token: "xoxp-2170858457-2731791470-3818967378-dc1f57", 
      username: payload[:user_handle],
      icon_url: payload[:user_avatar]
    }
  end
end
