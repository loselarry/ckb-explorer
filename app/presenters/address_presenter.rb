class AddressPresenter
  def initialize(object)
    @object = object.is_a?(Array) ? object : [object]
  end

  def id
    object.first.id
  end

  def address_hash
    object.first.address_hash
  end

  def balance
    object.reduce(0) { |sum, addr| sum + addr.balance.to_i }
  end

  def lock_script
    object.first.cached_lock_script
  end

  def pending_reward_blocks_count
    [object.reduce(0) { |sum, addr| sum + addr.pending_reward_blocks_count }, 0].max
  end

  def transactions_count
    ckb_transactions.count
  end

  def ckb_transactions
    ckb_transaction_ids = AccountBook.where(address_id: object.pluck(:id)).select(:ckb_transaction_id).distinct
    CkbTransaction.where(id: ckb_transaction_ids).recent
  end

  private

  attr_reader :object
end