class FaradayClient
  def request(method, url, body = {})
    resp = connection.send(method) do |req|
      case method
      when :get
        req.url url, body
      when :post
        req.url url
        req.headers['Content-Type'] = 'application/json'
        # Slack requests must be passed as params
        req.params = body unless body.empty?
        # req.body = body.to_json unless body.empty?
      end
    end

    body.delete('token')

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

  def post(url, body = {})
    request :post, url, body
  end
end




