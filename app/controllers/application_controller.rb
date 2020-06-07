require_relative "../models/blockchain"
class ApplicationController < ActionController::Base
  before_action :set_blockchain

  private

    def sort_hash_by_key(hash)
      hash.sort.to_h
    end

    def set_blockchain
      @blockchain = Blockchain.new
    end
end
