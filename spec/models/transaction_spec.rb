require 'rails_helper'

describe Transaction do
  it { should belong_to :stock }

  it { should validate_presence_of :price }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :date }
  it { should validate_presence_of :trade_type }

  it { should validate_numericality_of(:price) }
  it { should validate_numericality_of(:quantity).only_integer }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }

  it { should define_enum_for(:trade_type).with(Transaction::TRANSACTION_TYPES.keys) }
end