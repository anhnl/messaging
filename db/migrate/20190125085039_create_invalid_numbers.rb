class CreateInvalidNumbers < ActiveRecord::Migration
  def change
    create_table :invalid_numbers do |t|
      t.string :number

      t.timestamps
    end

    add_index :invalid_numbers, :number
  end
end
