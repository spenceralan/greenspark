require 'rails_helper'

describe Stock do
  it { should belong_to :user }
  it { should have_many :transactions }

  it { should validate_presence_of :symbol }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }

end