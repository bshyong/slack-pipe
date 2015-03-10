class AsmPayload

  def self.prepare(message_log_id)
    message_log = MessageLog.find(message_log_id)
    slack_room = message_log.slack_room

    clean_msg_body = self.clean_body(message_log.msg_text)

    user = slack_room.users
                      .where(
                        slack_user_id: message_log.user_id)
                      .first

    payload = {
      data: {
        message: clean_msg_body,
        product: slack_room.name,
        user_email: user.email,
        user_full_name: user.real_name,
        user_username: user.slack_handle
      }
    }
    payload.merge({auth: self.generate_headers(payload)})
  end

  def self.generate_headers(payload)
    body = Hash[payload[:data].sort_by(&:first)].to_json
    timestamp = Time.now.to_i
    prehash = "#{timestamp}#{body}"
    secret = Base64.decode64(ENV['SLACKPIPE_SECRET'])
    hash = OpenSSL::HMAC.digest('sha256', secret, prehash)
    signature = Base64.encode64(hash)
    {
      signature: signature,
      timestamp: timestamp
    }
  end

  # TODO: could use clean up
  def self.clean_body(body)
    matches =  body.match(/<(.*?)>/).try(:captures)

    return body if matches.nil?
    matches.each do |m|

      first_two = m.slice(0,2)

      if first_two[0] == '!'
        body.gsub!("<#{m}>", '@' + m.slice(1..-1))
      elsif first_two == '#C'
        channel = SlackChannel.find_by!(slack_channel_id: m.slice(1..-1)).try(:channel_name)
        body.gsub!("<#{m}>", '#' + channel) unless channel.nil?
      elsif first_two == '@U'
        name = User.find_by!(slack_user_id: m.slice(1..-1)).try(:slack_handle)
        body.gsub!("<#{m}>", '@' + name) unless name.nil?
      else
        # it's a link
        pipe = m.index('|')
        body.gsub!("<#{m}>", "[#{m.slice(pipe+1..-1)}](#{m.slice(0, pipe)})") unless pipe.nil?
      end
    end
    body
  end

end