# SlackRoom.connection
SlackRoom.all.each do |sr|
  SlackRoomPipe.new(slackroom: sr).start!
end

