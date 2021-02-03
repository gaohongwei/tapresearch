require "base64"
require_relative "./common/http_status_codes"
#### Attention ####
# We may create a base class for Services if we have more services in the future
class TapresearchService
  include HttpStatusCodes

  API_ENDPOINT="https://staging.tapresearch.com"
  INDEX_ENDPOINT="/api/v1/campaigns"
  SHOW_ENDPOINT="/api/v1/campaigns/%{id}"

  attr_reader :api_token, :email

  def initialize(email: "codetest@tap.com", api_token: "1c7dd6fd2a94b2e6431b367189aead01")
    @api_token = api_token
    @email = email
  end

  def get_campaigns(params=nil)
    request(
      http_method: :get,
      endpoint: INDEX_ENDPOINT
    )
  end

  def get_campaign(id)
    request(
      http_method: :get,
      endpoint: SHOW_ENDPOINT % {id: id}
    )
  end

  private

  def request_token
    raw_infor =  "#{email}:#{api_token}"
    encoded = Base64.strict_encode64(raw_infor)
    return "Basic #{encoded}"
  end

  def client
    @_client ||= Faraday.new(API_ENDPOINT) do |client|
      client.request :url_encoded
      client.adapter Faraday.default_adapter
      client.headers['Authorization'] = request_token
      client.headers['Content-Type'] = "application/json"
    end
  end

  def succeed?(status)
    status === HTTP_OK_CODE
  end

  def request(http_method:, endpoint:, params: {})
    begin
      response = client.public_send(http_method, endpoint, params)
      parsed_response = Oj.load(response.body)
      unified_output = {
        succeed: succeed?(response.status),
        data: parsed_response
      }
    rescue StandardError => e
      unified_output = {
        succeed: false,
        error: e.message,
        data: [],
      }
    end
    #### Attention ####
    # I dont want to throw exception here because the caller has to catch it
    # Instead, I just give status code
    # More data should be added for pagination,
    # Totoal count,
    # page size, page number
    unified_output
  end

end
