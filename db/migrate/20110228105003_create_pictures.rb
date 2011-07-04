class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|

      t.timestamps
      t.string :subject, :null => false
      t.integer :part_id, :null => false

      # for paperclip
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.integer :photo_cached_width_original
      t.integer :photo_cached_height_original
      t.integer :photo_cached_width_thumb
      t.integer :photo_cached_height_thumb
      t.integer :photo_cached_width_resized
      t.integer :photo_cached_height_resized

      t.integer :type_id, :default => 1, :null => false
      t.boolean :is_approved
    end
    add_index :pictures, [:part_id, :type_id]
  end

  def self.down
    drop_table :pictures
  end
end
