class CreateGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :guests do |t|
      t.string :token
      t.string :ip
      t.string :deviceType
      t.string :deviceId
      t.string :deviceModel
      t.string :timeZone

      t.timestamps
    end
  end
end
