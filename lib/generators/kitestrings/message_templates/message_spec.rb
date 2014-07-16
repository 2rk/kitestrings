require 'spec_helper'

describe Message do

  let(:freeze_1) { Time.zone.now.change(:usec => 0) }

  common_lets

  context "relationships" do
    it { should belong_to(:user) }
    it { should belong_to(:context) }
  end

  context "validations" do
    # validate the common_lets generated message instance:
    it { expect(message).to be_valid }
    it { should validate_presence_of(:user) }
  end

  describe 'latest' do
    before do
      Timecop.freeze(Time.local(1990)) do
        message_other
        message
      end
    end
    it { expect(Message.latest).to match_array([message_other, message]) }
  end

  describe "#mail" do
    # Example test for mail content:
    # let(:message) { Message.new(template: "report_untag", context: relation, options: {foo: "bar"}, user: user_owner) }
    # context "rendering email" do
    #   subject { message.mail }
    #   it { expect(subject.subject).to eq("Tag Removed Notification") }
    #   it { expect(subject.body).to include("The following tag has just been removed") }
    # end
  end

  describe "#view_link" do
    subject { message }
    it "production" do
      Rails.application.routes.stub(:default_url_options => {:host => 'example.com'})
      Rails.env.stub(:production? => true)
      expect(subject.view_link).to eq("http://example.com/messages/#{message.id}")
    end
    it "development" do
      expect(subject.view_link).to eq("http://localhost/messages/#{message.id}")
    end
  end


  context '#send_email' do
    context 'build only' do
      before do
        message.update_column(:sent_at, nil)
        ActionMailer::Base.deliveries.clear
        message.mail
      end
      it { expect(message.sent_at).to be_nil }
      it { ActionMailer::Base.deliveries.should be_empty }
    end

    context 'build and send' do
      before do
        Timecop.freeze(freeze_1) { message.send_email }
      end

      it { ActionMailer::Base.deliveries.last.to.should == [user.email] }
      it { message.sent_at.should == freeze_1 }
    end
  end
end
