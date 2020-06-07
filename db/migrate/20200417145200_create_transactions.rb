class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.boolean :is_transaction_pool, null: false
      t.text :sender_blockchain_address, null: false
      t.text :recipient_blockchain_address, null: false
      t.float :value, null: false
      t.belongs_to :block
      t.timestamps
    end
  end
end
