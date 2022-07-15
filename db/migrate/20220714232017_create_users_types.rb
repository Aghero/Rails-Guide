class CreateUsersTypes < ActiveRecord::Migration
  def self.up
    create_table :user_types_users, {id: false} do |t|
      t.references :user, :null => false
      t.references :user_type, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_types_users
  end
end
