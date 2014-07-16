require 'spec_helper'

describe MessagesController do
  render_views
  common_lets

  before :all do
    Fracture.define_selector :new_message_link
    Fracture.define_selector :cancel_new_message_link
    Fracture.define_selector :edit_message_link
    Fracture.define_selector :cancel_edit_message_link
  end

  context 'not logged in' do
    {index: :get, show: :get}.each do |v, m|
      it "#{m} #{v} should logout" do
        self.send(m, v, id: message)
        should redirect_to new_user_session_path
      end
    end
  end

  context "signed in" do
    before do
      sign_in user
      controller.should_receive(:authenticate_user!).and_call_original
    end

    context "GET index" do
      context "not nested" do
        before do
          controller.should_receive(:authorize!).with(:index, Message)
          message; message_other
          get :index
        end
        it { should assign_to(:messages).with_items([message]) }
        it { should render_template :index }
        it { should have_only_fractures }
      end

      context "under user" do
        before do
          controller.should_receive(:authorize!).with(:show, user)
          controller.should_receive(:authorize!).with(:index, user => Message)
          controller.should_receive(:authorize!).with(:index, Message)
          message; message_other
          get :index, :user_id => user.id
        end
        it { should assign_to(:messages).with_items([message]) }
        it { should render_template :index }
        it { should have_only_fractures }
      end
    end

    context "GET show" do
      context "not nested" do # this is the redirect action. This link appears in the email.
        before do
          message.update_column :link, "/some/location"
          Timecop.freeze(freeze_1) do
            get :show, id: message
          end
        end

        it { should assign_to(:message).with(message) }
        it { should assign_to("message.clicked_at").with(freeze_1) }
        it { should_not render_template :show }
        it { should redirect_to("/some/location") }
      end

      # context 'not as the owner of the message' do
      #   it { expects_access_denied { get :show, id: message_other } }
      # end

      context "under user" do
        before do
          controller.should_receive(:authorize!).with(:show, user)
          controller.should_receive(:authorize!).with(:show, message)
          get :show, user_id: user, id: message
        end
        it { should assign_to(:message).with(message) }
        it { should render_template :show }
        it { should have_only_fractures }
      end
    end
  end
end
