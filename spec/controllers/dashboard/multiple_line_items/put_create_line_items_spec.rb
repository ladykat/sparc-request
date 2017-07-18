# Copyright © 2011-2016 MUSC Foundation for Research Development~
# All rights reserved.~

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:~

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.~

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following~
# disclaimer in the documentation and/or other materials provided with the distribution.~

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products~
# derived from this software without specific prior written permission.~

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,~
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT~
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL~
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS~
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR~
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.~

require "rails_helper"

RSpec.describe Dashboard::MultipleLineItemsController do
  describe "PUT #create_line_items" do
    before(:each) do
      identity = build_stubbed(:identity)
      @protocol = create(:protocol_with_ssr_without_validations, primary_pi: identity)
      @service = create(:service_without_validations)
      log_in_dashboard_identity(obj: identity)
      put :create_line_items, params: { 
                            service_request_id: @protocol.service_requests.first.id, 
                            sub_service_request_id: @protocol.sub_service_requests.first.id,
                            add_service_id: @service.id }, 
                            xhr: true

    end

    it "assigns the correct instance variables" do
      expect(assigns(:service_request)).to eq(@protocol.service_requests.first)
      expect(assigns(:sub_service_request)).to eq(@protocol.sub_service_requests.first)
      expect(assigns(:service)).to eq(@service)
    end

    it "creates new line items on success" do
      expect{ put :create_line_items, params: { 
                            service_request_id: @protocol.service_requests.first.id, 
                            sub_service_request_id: @protocol.sub_service_requests.first.id,
                            add_service_id: @service.id }, 
                            xhr: true}.to change{LineItem.count}.by(1)
    end

    it "doesn't create new line items on failure" do
      @sr = findable_stub(ServiceRequest){ @protocol.service_requests.first }
      allow(@sr).to receive(:create_line_items_for_service){ false }
      expect{ put :create_line_items, params: { 
                            service_request_id: @sr.id, 
                            sub_service_request_id: @protocol.sub_service_requests.first.id,
                            add_service_id: @service.id }, 
                            xhr: true}.to_not change{LineItem.count}
    end

    it { is_expected.to render_template "dashboard/multiple_line_items/create_line_items" }

    it { is_expected.to respond_with :ok }
  end
end
