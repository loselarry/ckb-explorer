class UdtSerializer
  include FastJsonapi::ObjectSerializer

  attributes :symbol, :full_name, :icon_file

  attribute :total_amount do |object|
    object.total_amount.to_s
  end
  attribute :addresses_count do |object|
    object.addresses_count.to_s
  end
  attribute :decimal do |object|
    object.decimal.to_s
  end
end