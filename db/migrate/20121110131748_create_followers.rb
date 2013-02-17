class CreateFollowers < ActiveRecord::Migration
  def up
    create_table :followers do |t|
      t.string  :screen_name, :null => false
      t.integer :uid, :null => false
      t.timestamps
    end # create_table :followers do |t|
  end

  def down
  end
end
