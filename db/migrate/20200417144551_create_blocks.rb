class CreateBlocks < ActiveRecord::Migration[6.0]
  def change
    create_table :blocks do |t|
      t.integer :nonce, null: false
      t.string :previous_hash, null: false
      t.timestamp :timestamp, null: false
      t.timestamps
    end
  end
end
