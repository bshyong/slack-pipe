module Slack
  class Worker < FaradayClient
    include Sidekiq::Worker

    def connection
      Faraday.new(url: 'https://slack.com/api/') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  :net_http
      end
    end
  end
end
