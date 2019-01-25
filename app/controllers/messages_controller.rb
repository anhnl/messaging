class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :desc).page 1
  end
end