require 'rails_helper'

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller do
  describe 'routing' do
<% unless options[:singleton] -%>
    it('routes to #index') { expect(get('/<%= ns_table_name %>')).to route_to('<%= ns_table_name %>#index') }
<% end -%>
    it('routes to #new') { expect(get('/<%= ns_table_name %>/new')).to route_to('<%= ns_table_name %>#new') }
    it('routes to #show') { expect(get('/<%= ns_table_name %>/1')).to route_to('<%= ns_table_name %>#show', id: '1') }
    it('routes to #edit') { expect(get('/<%= ns_table_name %>/1/edit')).to route_to('<%= ns_table_name %>#edit', id: '1') }
    it('routes to #create') { expect(post('/<%= ns_table_name %>')).to route_to('<%= ns_table_name %>#create') }
    it('routes to #update') { expect(put('/<%= ns_table_name %>/1')).to route_to('<%= ns_table_name %>#update', id: '1') }
    it('routes to #destroy') { expect(delete('/<%= ns_table_name %>/1')).to route_to('<%= ns_table_name %>#destroy', id: '1') }
  end
end
<% end -%>
