namespace :slack do
  desc "Pull old messages from Slack"
  task populate: :environment do
    SlackRoom.all.each do |sr|
      Slack::InitializeRoom.new.perform(sr.id)
      response = fetch_messages(sr)

      while response['has_more'] == true
        response = fetch_messages(sr, response['messages'].last['ts'])
      end

    end
  end

  task create_channels: :environment do
    
  end

    def fetch_messages(slack_room, latest=nil)
      response = Slack::Worker.new.get('channels.history', {token: slack_room.token, 
                                                            channel: slack_room.general_channel,
                                                            latest: latest})
      puts "fetching #{response.fetch('messages').count} messages; #{latest}"
      response.fetch('messages').each do |m|
        MessageLog.create(
          user_id: m['user'],
          slack_room_id: slack_room.id,
          timestamp: Integer(m['ts'].gsub('.', '')),
          msg_text: m['text'],
          msg_type: m['type'],
          msg_subtype: m.fetch('subtype', nil),
          channel: slack_room.general_channel
        )
      end
      response
    end

end
