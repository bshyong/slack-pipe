class SlackPublisher
  def self.post(payload = {})
    payload.merge!({as_user: false})
    # username
    # icon_url
    # SlackhookWorker.perform_async(payload)
  end


  # before publishing to Slack
  # & replaced with &amp;
  # < replaced with &lt;
  # > replaced with &gt;

  def asmtest
    payload = {
      message: MessageLog.last.attributes,
      user: MessageLog.last.slack_room.users
                      .where(
                        slack_user_id: MessageLog.last.user_id)
                      .first.try(:attributes),
      product: MessageLog.last.slack_room.name
    }
    post('', payload)
  end

  def testpost(msg: '')
    payload = {
      text: "this is a test &amp; #{Time.now}. \n #{msg}",
      channel: "C03TTCR5P",
      token: "xoxp-2170858457-2731791470-3818967378-dc1f57"
    }
    post('chat.postMessage', payload)
  end

  # def connection
  #   Faraday.new(url: 'http://localhost:5000/api/sb') do |faraday|
  #     faraday.request  :url_encoded
  #     faraday.adapter  :net_http
  #   end
  # end


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
        req.headers['Content-Type'] = 'application/json'
        req.params = body unless body.empty?
        req.body = body.to_json
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
    request :get, url, body
  end

  def post(url, body = {})
    request :post, url, body
  end

end
