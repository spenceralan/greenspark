require 'rails_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should have_many :stocks }

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_uniqueness_of(:username).case_insensitive }

end

