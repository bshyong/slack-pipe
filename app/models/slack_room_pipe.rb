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
      Rails.logger.info "started listening to room #{@slackroom.name}"
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
          subtype = msg.fetch('subtype', nil)

          if subtype.nil? || ALLOWED_SUBTYPES.include?(subtype.to_sym)
            Rails.logger.info "#{subtype.nil? ? msg['type'] : subtype} in #{@slackroom.name}, channel #{msg['channel']}"
            begin

              chat_room = @slackroom.chat_rooms.find_by(channel: msg['channel'])

              MessageLog.create(
                user_id: msg['user'], 
                channel: msg['channel'],
                msg_type: msg['type'],
                msg_subtype: subtype,
                msg_text: msg['text'],
                slack_room_id: @slackroom.id,
                chat_room_id: chat_room.try(:id),
                timestamp: Integer(msg['ts'].gsub('.', ''))
              )

            rescue ActiveRecord::RecordNotUnique
              Rails.logger.info "RESCUE: #{msg['text']}"
            end
          end
        end
      end
      t.abort_on_exception = true
    rescue
      Rails.logger.info "room #{@slackroom.name} crashed..restarting"
      self.start!
    end
  end
end
