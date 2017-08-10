RSpec.configure do |config|
  config.before :each do
    stub_request(:get, /www.alphavantage.co/).
    to_return(:status => 200, :body => Rails.root.join("spec", "fixtures", "alpha_vantage.json").read, :headers => {})
  end
end