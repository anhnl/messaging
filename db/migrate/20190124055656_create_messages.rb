class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :to_number
      t.text    :message
      t.integer :message_status
      t.string  :provider_message_id

      t.timestamps
    end
  end
end
