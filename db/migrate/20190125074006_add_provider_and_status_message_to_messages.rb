class AddProviderAndStatusMessageToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :provider, :string
    add_column :messages, :status_message, :string
  end
end
