require 'rails_helper'

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller do
  fixtures :<%=table_name %>
  common_lets

  before :all do
    Fracture.define_selector :new_<%= file_name %>_link
    Fracture.define_selector :cancel_new_<%= file_name %>_link
    Fracture.define_selector :edit_<%= file_name %>_link
    Fracture.define_selector :cancel_edit_<%= file_name %>_link
  end

  # stub strong params
  before { allow(controller).to receive(:<%= file_name %>_params).and_return({}) }

  context 'not logged in' do
    before { sign_out :user }

    { index: :get, show: :get, new: :get, create: :post, edit: :get, update: :put,
      destroy: :delete }.each do |v, m|
      it "#{m} #{v} should logout" do
        send(m, v, id: <%= file_name %>)
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  context 'logged in as user' do
    before { sign_in user }

<% unless options[:singleton] -%>
    describe 'GET index' do
      before do
        <%= file_name %>; <%= file_name %>_other
        get :index
      end

      it { is_expected.to assign_to(:<%= table_name %>).with_items(<%= file_name %>) }
      it { is_expected.to render_template :index }
      it { is_expected.to have_only_fractures(:new_<%= file_name %>_link) }
    end
<% end -%>

    describe 'GET show' do
      before { get :show, id: <%= file_name %> }

      it { is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>) }
      it { is_expected.to render_template :show }
      it { is_expected.to have_only_fractures(:edit_<%= file_name %>_link) }
    end

    describe 'GET new' do
      before { get :new }

      it { is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>) }
      # it { is_expected.to assign_to('<%= file_name %>.parent').with(parent) }
      it { is_expected.to render_template :new }
      it { is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link }
      it { is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path) }
    end

    describe 'POST create' do
      context 'valid' do
        before do
          allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(true)
          post :create
        end

        it { is_expected.to redirect_to <%= file_name %>_path(<%= class_name %>.last) }
        it { is_expected.to assign_to(:<%= file_name %>).with(<%= class_name %>.last) }
        # it { is_expected.to assign_to('<%= file_name %>.parent').with(parent) }
      end

      context 'invalid' do
        before do
          allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(false)
          post :create
        end

        it { is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>) }
        # it { is_expected.to assign_to('<%= file_name %>.parent').with(parent) }
        it { is_expected.to render_template :new }
        it { is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link }
        it { is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path) }
      end
    end

    describe 'GET edit' do
      before { get :edit, id: <%= file_name %> }

      it { is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>) }
      it { is_expected.to render_template :edit }
      it { is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link }
      it { is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path) }
    end

    describe 'PUT update' do
      context 'valid' do
        before do
          allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(true)
          put :update, id: <%= file_name %>
        end

        it { is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>) }
        it { is_expected.to redirect_to <%= file_name %>_path(<%= file_name %>) }
      end
      context 'invalid' do
        before do
          <%= file_name %>
          allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(false)
          put :update, id: <%= file_name %>
        end

        it { is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>) }
        it { is_expected.to render_template :edit }
        it { is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link }
        it { is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path) }
      end
    end

    describe 'DELETE destroy' do
      before { delete :destroy, id: <%= file_name %> }

      it { expect(<%= class_name %>.find_by_id(<%= file_name %>.id)).to be_nil }
      it { is_expected.to redirect_to <%= index_helper %>_path }
    end
  end
end
<% end -%>
