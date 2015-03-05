module SlackRequest
  class Worker
    include Sidekiq::Worker

    def connection
      Faraday.new(url: 'https://api.github.com') do |faraday|
        faraday.adapter  :net_http
      end
    end

    def request(method, url, body)
      resp = connection.send(method) do |req|
        req.url url
        req.headers['Authorization'] = "token #{ENV['GITHUB_USER_TOKEN']}"
        req.body = body.to_json
      end

      log = ['  ', method, url, body.inspect, "[#{resp.status}]"]
      if !resp.success?
        log << resp.body.inspect
      end
      Rails.logger.info log.join(' ')

      JSON.load(resp.body)
    end

    def get(url, body = {})
      request :get, url, body
    end
  end
end
