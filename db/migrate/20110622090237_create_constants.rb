class CreateConstants < ActiveRecord::Migration
  def self.up
    create_table :constants do |t|
      t.string :name, :null => false
      t.string :value
    end
  end

  def self.down
  end
end
