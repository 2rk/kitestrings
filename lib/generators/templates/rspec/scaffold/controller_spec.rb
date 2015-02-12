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

  context 'logged in' do
    before do |meta|
      allow(controller).to receive(:<%= file_name %>_params).and_return({}) # strong params
      allow(user).to receive(:role).and_return(meta.metadata[:role]) # setting user role
      allow(request.env['warden']).to receive(:authenticate!) { user } # stubbing authen
      allow(controller).to receive(:current_user) { user } # stubbing current_user
    end

<% unless options[:singleton] -%>
    describe 'GET index' do
      before { |meta| get :index, get_nesting(meta) }

      context 'un-nested' do
        it 'default role', role: :default do
          is_expected.to assign_to(:<%= table_name %>).with_items(<%= file_name %>, <%= file_name %>_other)
          is_expected.to render_template :index
          is_expected.to have_only_fractures(:new_<%= file_name %>_link)
        end
        # context 'nested under company', company_id: :company do
        #   it 'default role', role: :default do
        #     is_expected.to assign_to(:<%= table_name %>).with_items(<%= file_name %>)
        #     is_expected.to assign_to(:company).with_items(company)
        #     is_expected.to render_template :index
        #     is_expected.to have_only_fractures(:new_<%= file_name %>_link)
        #   end
        # end
      end
    end
<% end -%>

    describe 'GET show' do
      before { |meta| get :show, get_nesting(meta, id: <%= file_name %>) }

      context 'un-nested' do
        it 'default role', role: :default do
          is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
          is_expected.to render_template :show
          is_expected.to have_only_fractures(:edit_<%= file_name %>_link)
        end
        # context 'nested under company', company_id: :company do
        #   it 'default role', role: :default do
        #     is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
        #     is_expected.to assign_to(:company).with_items(company)
        #     is_expected.to render_template :show
        #     is_expected.to have_only_fractures(:edit_<%= file_name %>_link)
        #   end
        # end
      end
    end

    describe 'GET new' do
      before { |meta| get :new, get_nesting(meta) }

      context 'un-nested' do
        it 'default role', role: :default do
          is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>)
          is_expected.to render_template :new
          is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link
          is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path)
        end
        # context 'nested under company', company_id: :company do
        #   it 'default role', role: :default do
        #     is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>)
        #     is_expected.to assign_to(:company).with_items(company)
        #     is_expected.to assign_to('<%= file_name %>.parent').with(parent)
        #     is_expected.to render_template :new
        #     is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link
        #     is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path)
        #   end
        # end
      end
    end

    describe 'POST create' do
      before do |meta|
        allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(meta.metadata[:valid])
        post :create, get_nesting(meta)
      end

      context 'un-nested' do
        context 'default role', role: :default do
          it 'valid', valid: true do
            is_expected.to redirect_to <%= file_name %>_path(<%= class_name %>.last)
            is_expected.to assign_to(:<%= file_name %>).with(<%= class_name %>.last)
          end
          it 'invalid', valid: false do
            is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>)
            is_expected.to render_template :new
            is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link
            is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path)
          end
        end
        # context 'nested under company', company_id: :company do
        #   context 'default role', role: :default do
        #     it 'valid', valid: true do
        #       is_expected.to redirect_to <%= file_name %>_path(<%= class_name %>.last)
        #       is_expected.to assign_to(:<%= file_name %>).with(<%= class_name %>.last)
        #       is_expected.to assign_to(:company).with_items(company)
        #       is_expected.to assign_to('<%= file_name %>.parent').with(parent)
        #     end
        #     it 'invalid', valid: false do
        #       is_expected.to assign_to(:<%= file_name %>).with_kind_of(<%= class_name %>)
        #       is_expected.to assign_to('<%= file_name %>.parent').with(parent)
        #       is_expected.to assign_to(:company).with_items(company)
        #       is_expected.to render_template :new
        #       is_expected.to have_only_fractures :cancel_new_<%= file_name %>_link
        #       is_expected.to have_a_form.that_is_new.with_path_of(<%= table_name %>_path)
        #     end
        #   end
        # end
      end
    end

    describe 'GET edit' do
      before { |meta| get :edit, get_nesting(meta, id: <%= file_name %>) }

      context 'un-nested' do
        it 'default role', role: :default do
          is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
          is_expected.to render_template :edit
          is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link
          is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path)
        end
        # context 'nested under company', company_id: :company do
        #   it 'default role', role: :default do
        #     is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
        #     is_expected.to assign_to(:company).with_items(company)
        #     is_expected.to render_template :edit
        #     is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link
        #     is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path)
        #   end
        # end
      end
    end

    describe 'PUT update' do
      before do |meta|
        allow_any_instance_of(<%= class_name %>).to receive(:valid?).and_return(meta.metadata[:valid])
        put :update, get_nesting(meta, id: <%= file_name %>)
      end

      context 'un-nested' do
        context 'default role', role: :default do
          it 'valid', valid: true do
            is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
            is_expected.to redirect_to <%= file_name %>_path(<%= file_name %>)
          end
          it 'invalid, valid: false' do
            is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
            is_expected.to render_template :edit
            is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link
            is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path)
          end
        end
        # context 'nested under company', company_id: :company do
        #   context 'default role', role: :default do
        #     it 'valid', valid: true do
        #       is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
        #       is_expected.to assign_to(:company).with_items(company)
        #       is_expected.to redirect_to <%= file_name %>_path(<%= file_name %>)
        #     end
        #     it 'invalid', valid: false do
        #       is_expected.to assign_to(:<%= file_name %>).with(<%= file_name %>)
        #       is_expected.to assign_to(:company).with_items(company)
        #       is_expected.to render_template :edit
        #       is_expected.to have_only_fractures :cancel_edit_<%= file_name %>_link
        #       is_expected.to have_a_form.that_is_edit.with_path_of(<%= file_name %>_path)
        #     end
        #   end
        # end
      end
    end

    describe 'DELETE destroy' do
      before { |meta| delete :destroy, get_nesting(meta, id: <%= file_name %>) }
      context 'un-nested' do
        it 'default role', role: :default do
          expect(<%= class_name %>.find_by_id(<%= file_name %>.id)).to be_nil
          is_expected.to redirect_to <%= index_helper %>_path
        end
        # context 'nested under company', company_id: :company do
        #   it 'default role', role: :default do
        #     expect(<%= class_name %>.find_by_id(<%= file_name %>.id)).to be_nil
        #     is_expected.to assign_to(:company).with_items(company)
        #     is_expected.to redirect_to <%= index_helper %>_path
        #   end
        # end
      end
    end
  end
end
<% end -%>
