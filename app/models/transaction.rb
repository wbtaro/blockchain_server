class Transaction < ApplicationRecord
  belongs_to :block, optional: true

  def to_hash
    {
      sender_blockchain_address: self.sender_blockchain_address,
      recipient_blockchain_address: self.recipient_blockchain_address,
      value: self.value.to_f
    }.sort.to_h
  end
end
