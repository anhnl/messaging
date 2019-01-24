class Message < ActiveRecord::Base

  validates :to_number, presence: true
  validates :message, presence: true

  enum message_status: {
    "created" => 0,
    "delivered" => 1,
    "failed" => 2,
    "invalid_message" => 3,
  }

end