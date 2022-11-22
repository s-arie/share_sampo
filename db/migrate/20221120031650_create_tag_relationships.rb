class CreateTagRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_relationships do |t|

      t.integer :post_image_id, null: false
      t.integer :tag_id, null: false
      
      t.timestamps null: false
    end
  end
end
