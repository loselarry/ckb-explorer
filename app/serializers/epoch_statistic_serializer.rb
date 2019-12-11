class EpochStatisticSerializer
  include FastJsonapi::ObjectSerializer

  attribute :epoch_number do |object|
    object.epoch_number.to_s
  end

  attribute :difficulty, if: Proc.new { |_record, params|
    params && params[:indicator].include?("difficulty")
  }

  attribute :uncle_rate, if: Proc.new { |_record, params|
    params && params[:indicator].include?("uncle_rate")
  }
end
