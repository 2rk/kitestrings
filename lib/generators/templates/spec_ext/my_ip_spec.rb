require_relative 'rails_helper_ext'

describe "My IP" do
  it "has an I Paddress" do
    expect(Net::HTTP.get("bot.whatismyipaddress.com", '/')).to match(/\d*\.\d*\.\d*\.\d*/)
  end
end
