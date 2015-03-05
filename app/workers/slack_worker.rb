class SlackWorker
  # class Worker
    include Sidekiq::Worker

    def connection
      Faraday.new(url: 'https://slack.com/api/') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  :net_http
      end
    end

    def request(method, url, body = {})
      resp = connection.send(method) do |req|
        case method
        when :get
          req.url url, body
        when :post
          req.url url
          req.body = body.to_json unless body.empty?
        end
      end

      log = ['  ', method, url, body.inspect, "[#{resp.status}]"]
      if !resp.success?
        log << resp.body.inspect
      end

      Rails.logger.info log.join(' ')

      JSON.load(resp.body)
    end

    def get(url, body = {}, token = nil)
      request :get, url, body.merge({token: token})
    end

    def post(url, body = {}, token = nil)
      request :post, url, body.merge({token: token})
    end

    def perform(slack_room_id)
      room = SlackRoom.find(slack_room_id)
      channels = get('channels.list', {}, room.token).fetch('channels')
      general_channel_id = channels.find{|c| c['is_general'] == true }['id']
      room.update general_channel: general_channel_id
    end
  # end
end
