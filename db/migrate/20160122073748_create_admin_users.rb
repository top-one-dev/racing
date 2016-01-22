class CreateAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
  	  t.string :username
      t.string :email
      t.string :encrypted_password 
      t.string :salt

      t.timestamps null: false
    end
  end
end
