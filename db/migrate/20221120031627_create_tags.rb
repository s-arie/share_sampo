class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|

      t.string :tag_name, unique: true
      t.index :tag_name, unique: true
      t.timestamps null: false
    end
  end
end
