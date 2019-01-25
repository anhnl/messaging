class Message < ActiveRecord::Base

  paginates_per 20

  validates :to_number, presence: true
  validates :message, presence: true

  after_update :add_to_invalid_numbers, if: lambda { message_status_changed? }

  enum message_status: {
    "created" => 0,
    "delivered" => 1,
    "failed" => 2,
    "invalid_number" => 3,
  }

  def add_to_invalid_numbers
    if self.message_status == "invalid_number"
      InvalidNumber.create!(number: self.to_number)
    end
  end

end