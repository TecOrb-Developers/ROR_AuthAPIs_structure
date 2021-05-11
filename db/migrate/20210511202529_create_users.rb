class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :fullName
      t.string :email
      t.string :password_digest
      t.string :countryCode
      t.string :contactNumber

      t.timestamps
    end
  end
end
