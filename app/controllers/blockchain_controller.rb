class BlockchainController < ApplicationController
  before_action :set_blockchain

  # GET /blockchains.json
  def index
    render json: {
      transaction_pool: @blockchain.transaction_pool,
      chain: @blockchain.chain,
      blockchain_address: @blockchain.the_blockchain_address
    }
  end

  def mining
    is_mined =  @blockchain.mining
    if is_mined
      logger.info("mining succeed!!")
      render status: 200 ,json: {status: 200, message: "success"}
    else
      logger.info("mining fail")
      render status: 400 ,json: {status: 400, message: "fail"}
    end
  end
end
