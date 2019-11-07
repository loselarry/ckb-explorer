class AddressSerializer
  include FastJsonapi::ObjectSerializer

  attributes :address_hash, :lock_script
  attribute :balance do |object|
    object.balance.to_s
  end
  attribute :transactions_count do |object|
    object.transactions_count.to_s
  end
  attribute :pending_reward_blocks_count do |object|
    object.pending_reward_blocks_count.to_s
  end
end
