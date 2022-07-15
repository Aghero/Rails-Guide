class CreateUsersTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types_users do |t|
      t.references :user
      t.references :user_type

      t.timestamps
    end
  end

  def self.down
    drop_table :user_types_users
  end
end
