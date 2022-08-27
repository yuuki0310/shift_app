class CreateStoreSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :store_submissions do |t|
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end
