class MessageHandler
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def call
    save_and_send_to_provider
  end

  def save_and_send_to_provider
    msg = Message.new(params.merge(message_status: Message.message_statuses['created']))
    response = {}

    if msg.save
      resp, selected_provider = do_post

      payload = JSON.parse(resp.body).symbolize_keys
      msg.provider = selected_provider

      if payload.has_key?(:message_id)
        msg.provider_message_id = payload[:message_id]
        response = { success: payload[:message_id] }
      else
        msg.status_message = payload[:error]
        response = { error: payload[:error] }
      end
    else
      msg.status_message = msg.errors.full_messages
      response = { error: msg.errors.full_messages }
    end

    msg.save
    response
  end

  def do_post
    # provider.pick will pick a different provider than the previous one automatically
    selected = provider.pick
    response = HTTParty.post(selected, body: {
      to_number: to_number,
      message: message,
      callback_url: callback_url,
    }.to_json)

    retry_if_failed(response.code)
    [response, selected]
  end

  def retry_if_failed(code)
    case code
    when 200
      return
    when 500
      do_post
    end
  end

  def provider
    @provider ||= Provider.new
  end

  def message
    @_message ||= params[:message]
  end

  def to_number
    @_to_number ||= params[:to_number]
  end

  def callback_url
    "#{ENV['ROOT_URL']}/update_status/"
  end
end