class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.text :email
      t.integer :age
      t.integer :age_in_months

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
