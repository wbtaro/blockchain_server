class Block < ApplicationRecord
  has_many :transactions

  def self.initial_block
    initial_block = Block.new(
      nonce: 0,
      previous_hash: sha256_hash({}),
      timestamp: Time.now
    )
    initial_block.save
    initial_block
  end

  def self.sha256_hash(block)
    Digest::SHA256.hexdigest(block.to_s)
  end

  def to_hash
    transactions = self.transactions.map { |transaction| transaction.to_hash }
    unorderd_block_hash = {
      previous_hash: self.previous_hash,
      nonce: self.nonce,
      timestamp: self.timestamp,
      transactions: transactions
    }
    unorderd_block_hash.sort.to_h
  end
end
