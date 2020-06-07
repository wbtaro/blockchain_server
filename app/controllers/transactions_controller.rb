class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /blockchains.json
  def index
    transactions = @blockchain.transaction_pool
    render json: {
      transactions: transactions,
      length: transactions.size
    }
  end

  def create
    transaction = Transaction.new(
      sender_blockchain_address: params[:sender_blockchain_address],
      recipient_blockchain_address: params[:recipient_blockchain_address],
      value: params[:value].to_f,
      is_transaction_pool: true
    )
    transaction_is_created = @blockchain.create_transaction(transaction, params[:sender_public_key], params[:signature])
    if transaction_is_created
      logger.info("transaction succeed!!")
      render status: 200 ,json: {status: 200, message: "success"}
    else
      logger.info("transaction fail")
      render status: 400 ,json: {status: 400, message: "fail"}
    end
  end

  private
    def transaction_params
      params.require(:transaction).permit(:sender_blockchain_address, :recipient_blockchain_address, :value, :sender_public_key, :signature)
    end
end
