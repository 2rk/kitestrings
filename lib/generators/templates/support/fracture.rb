RSpec.configure do |config|
  config.after(:all) do
    Fracture.clear
  end
end
