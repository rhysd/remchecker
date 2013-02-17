class CreateRemovers < ActiveRecord::Migration
  def up
    create_table :removers do |t|
      t.string  :screen_name, :null => false
      t.integer :uid, :null => false
      t.timestamps
    end # create_table :remvoers do |t|
  end

  def down
  end
end
