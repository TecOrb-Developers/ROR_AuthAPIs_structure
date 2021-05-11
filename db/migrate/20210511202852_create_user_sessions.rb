class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.string :token
      t.string :device_id
      t.string :device_type
      t.string :device_model
      t.string :status
      t.string :timeZone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
