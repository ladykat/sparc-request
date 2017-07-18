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
  describe "GET #new_line_items" do
    before(:each) do
      identity = build_stubbed(:identity)
      @protocol = create(:protocol_with_ssr_without_validations, primary_pi: identity)
      @services = create_list(:service_without_validations, 3)
      @ssr = findable_stub(SubServiceRequest){ build_stubbed(:sub_service_request_without_validations) }
      allow(@ssr).to receive(:candidate_services){ @services }
      log_in_dashboard_identity(obj: identity)
      get :new_line_items, params: { 
                            service_request_id: @protocol.service_requests.first.id, 
                            sub_service_request_id: @ssr.id,
                            protocol_id: @protocol.id,
                            page_hash: "hash",
                            schedule_tab: "tab" }, 
                            xhr: true

    end

    it "assigns the correct instance variables" do
      expect(assigns(:service_request)).to eq(@protocol.service_requests.first)
      expect(assigns(:sub_service_request)).to eq(@ssr)
      expect(assigns(:services)).to eq(@services)
      expect(assigns(:protocol)).to eq(@protocol)
      expect(assigns(:page_hash)).to eq("hash")
      expect(assigns(:schedule_tab)).to eq("tab")
    end

    it { is_expected.to render_template "dashboard/multiple_line_items/new_line_items" }

    it { is_expected.to respond_with :ok }
  end
end
