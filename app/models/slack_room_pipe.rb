class SlackRoomPipe

  ALLOWED_SUBTYPES = [
    :message_changed,
    :file_share,
    :file_comment,
    :file_mention
  ]

  def initialize(slackroom:)
    @slackroom = slackroom
    @token = slackroom.token
  end

  def start!
    begin
      puts "started listening to room #{@slackroom.name}"
      messages = Queue.new

      t = Thread.new do
        # https://api.slack.com/web#basics
        url = SlackRTM.get_url token: @token
        client = SlackRTM::Client.new websocket_url: url
        client.on(:message) do |data|
          if data['type'] == 'message'
            messages << data
          end
        end
        # note: main_loop never returns
        client.main_loop
      end
      t.abort_on_exception = true

      t = Thread.new do
        loop do
          msg = messages.pop
          # https://api.slack.com/events/message
          subtype = msg.fetch(:msg_subtype, nil)

          if subtype.nil? || ALLOWED_SUBTYPES.include?(subtype.to_sym)
            p "#{subtype.nil? ? msg[:type] : subtype} in #{@slackroom.name}"
            MessageLog.create(
              user: msg[:user], 
              channel: msg[:channel],
              msg_type: msg[:type],
              msg_subtype: subtype,
              slack_room_id: @slackroom.id,
              timestamp: msg[:ts]
            )
          end
        end
      end
      t.abort_on_exception = true
    rescue
      puts "room #{@slackroom.name} crashed..restarting"
      self.start!
    end
  end
end
