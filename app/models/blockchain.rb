class Blockchain
  attr_reader :the_blockchain_address
  THE_BLOCKCHAIN_ADDRESS = "THE_BLOCKCHAIN"
  MINIG_REWARD = 10
  MINIG_DIFFICULTY = 2

  def initialize
    @the_blockchain_address = THE_BLOCKCHAIN_ADDRESS
  end

  def chain
    chain = all_blocks
    if chain.size == 0
      chain = [].push(Block.initial_block.to_hash)
    else
      chain = chain.map { |block| block.to_hash }
    end
    chain
  end

  def transaction_pool
    @_transaction_pool ||= Transaction.where(is_transaction_pool: true).map { |transaction| transaction.to_hash }
  end

  def create_transaction(transaction, sender_public_key, signature)
    add_transaction(transaction, sender_public_key, signature)
  end

  def add_transaction(transaction, sender_public_key=nil, signature=nil)
    if transaction.sender_blockchain_address == THE_BLOCKCHAIN_ADDRESS
      transaction.save
      return true
    end

    if verify_transaction_signature(transaction, sender_public_key, signature)
      transaction.save
      return true
    end
    false
  end

  def mining
    return false if transaction_pool.size == 0
    transaction = Transaction.new(
      sender_blockchain_address: THE_BLOCKCHAIN_ADDRESS,
      recipient_blockchain_address: "shimada",
      value: MINIG_REWARD.to_f,
      is_transaction_pool: true
    )
    add_transaction(transaction)
    nonce = calculate_nonce
    create_block(nonce, previous_hash)
    true
  end

  end

  private
    def all_blocks
      @_all_blocks ||= Block.all.order(:timestamp)
    end

    def verify_transaction_signature(transaction, sender_public_key, signature)
      message =  OpenSSL::Digest::SHA256.hexdigest(transaction.to_hash.to_s)
      key_obj = OpenSSL::PKey::EC.new("secp256k1")
      public_key_bn = OpenSSL::BN.new(sender_public_key, 16)
      key_obj.public_key = OpenSSL::PKey::EC::Point.new(key_obj.group, public_key_bn)
      key_obj.dsa_verify_asn1(message, signature)
    end

    def valid_proof(nonce)
      guess_block = {
          transactions: transaction_pool,
          nonce: nonce,
          previous_hash: previous_hash
      }.sort.to_h
      guess_hash = sha256_hash(guess_block)
      guess_hash[0...MINIG_DIFFICULTY] == "0" * MINIG_DIFFICULTY
    end

    def previous_hash
      # 最後のブロックの情報
      sha256_hash(chain[-1])
    end

    def sha256_hash(block)
      Digest::SHA256.hexdigest(block.to_s)
    end

    def calculate_nonce 
      nonce = 0
      while !valid_proof(nonce) do
        nonce += 1
      end
      nonce
    end

    def create_block(nonce, previous_hash)
      set_block_id_to_transaction_pool
      block = Block.new(
        timestamp: Time.now,
        nonce: nonce,
        previous_hash: previous_hash
      )
      block.save
      set_is_transaction_pool_to_false
    end

    def set_is_transaction_pool_to_false
      Transaction.where(is_transaction_pool: true).update_all(is_transaction_pool: false);
    end

    def set_block_id_to_transaction_pool
      Transaction.where(is_transaction_pool: true).update_all(block_id: all_blocks[-1].id)
    end
end
