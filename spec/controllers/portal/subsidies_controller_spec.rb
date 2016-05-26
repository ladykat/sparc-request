# Copyright © 2011 MUSC Foundation for Research Development
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rails_helper'

RSpec.describe Portal::SubsidiesController do
  stub_portal_controller

  let!(:institution)     { create(:institution) }
  let!(:provider)        { create(:provider, parent_id: institution.id) }
  let!(:program)         { create(:program, parent_id: provider.id) }
  let!(:core)            { create(:core, parent_id: program.id) }
  let!(:study)           { study = Study.create(attributes_for(:protocol)); study.save!(validate: false); study }
  let!(:service_request) { service_request = ServiceRequest.create(attributes_for(:service_request, protocol_id: study.id)); service_request.save!(validate: false); service_request }
  let!(:ssr)             { create(:sub_service_request, service_request_id: service_request.id, organization_id: core.id) }
  let!(:subsidy)         { create(:subsidy, sub_service_request_id: ssr.id) }

  describe 'POST update_from_fulfillment' do
    it 'should set subsidy' do
      # TODO
    end
  end

  describe 'POST create' do
    it 'should set subsidy' do
      post :create, {
        format: :js,
        subsidy: {
          sub_service_request_id: ssr.id,
        },
      }.with_indifferent_access
      expect(assigns(:subsidy)).not_to eq nil
      expect(assigns(:subsidy).sub_service_request).to eq ssr
    end

    it 'should set sub_service_request' do
      post :create, {
        format: :js,
        subsidy: {
          sub_service_request_id: ssr.id,
        },
      }.with_indifferent_access
      expect(assigns(:sub_service_request)).to eq ssr
    end

    it 'should set pi_contribution to direct_cost_total' do
      allow_any_instance_of(SubServiceRequest).to receive(:direct_cost_total).and_return(12.34)
      post :create, {
        format: :js,
        subsidy: {
          sub_service_request_id: ssr.id,
        },
      }.with_indifferent_access
      expect(assigns(:subsidy).pi_contribution).to eq 12 # pi_contribution is an integer
    end
  end

  describe 'POST destroy' do
    it 'should destroy the subsidy' do
      post :destroy, {
        format: :js,
        id: subsidy.id,
      }.with_indifferent_access
      expect { subsidy.reload }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(assigns(:subsidy)).to eq nil
    end

    it 'should set service_request and sub_service_request' do
      post :destroy, {
        format: :js,
        id: subsidy.id,
      }.with_indifferent_access
      expect(assigns(:sub_service_request)).to eq ssr
      expect(assigns(:service_request)).to eq service_request
    end
  end
end