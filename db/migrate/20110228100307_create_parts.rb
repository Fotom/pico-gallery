class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|

      t.timestamps
      t.string :name, :null => false
      t.integer :order_number

      t.text    :content
    end
    add_index :parts, :name
  end

  def self.down
    drop_table :parts
  end
end
