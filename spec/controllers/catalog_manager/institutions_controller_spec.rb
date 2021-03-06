# Copyright © 2011-2017 MUSC Foundation for Research Development~
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

require 'rails_helper'

RSpec.describe CatalogManager::InstitutionsController do
  let!(:logged_in_user) {create(:identity)}

  before :each do
    allow(controller).to receive(:authenticate_identity!).
      and_return(true)
    allow(controller).to receive(:current_identity).
      and_return(logged_in_user)
  end

  describe '#create' do
    before :each do
      post :create, params: { name: 'Some Institution' }, xhr: true
    end

    it 'should create an institution' do
      expect(Institution.count).to eq(1)
    end

    it 'should assign @organization' do
      expect(assigns(:organization)).to be_an_instance_of(Institution)
    end

    it 'should create a catalog_manager_rights' do
      expect(logged_in_user.catalog_manager_rights.count).to eq(1)
    end

    it { is_expected.to render_template "institutions/create" }
    it { is_expected.to respond_with :ok }
  end

  describe '#show' do
    before :each do
      @organization = create(:institution)
      logged_in_user.catalog_manager_rights.create( organization_id: @organization.id )

      get :show, params: { id: @organization.id }, xhr: true
    end

    it 'should assign @path' do
      expect(assigns(:path)).to eq(catalog_manager_institution_path(@organization))
    end

    it 'should assign @organization' do
      expect(assigns(:organization)).to eq(@organization)
    end

    it { is_expected.to render_template "organizations/show" }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    before :each do
      @organization = create(:institution, name: 'Some Institution')
      logged_in_user.catalog_manager_rights.create( organization_id: @organization.id )
      pricing_setup = {id: '',
                       display_date:   '2016-06-27',
                       effective_date: '2016-06-28',
                       federal:   '100',
                       corporate: '100',
                       other:     '100',
                       member:    '100',
                       college_rate_type:      'federal',
                       federal_rate_type:      'federal',
                       foundation_rate_type:   'federal',
                       industry_rate_type:     'federal',
                       investigator_rate_type: 'federal',
                       internal_rate_type:     'federal',
                       unfunded_rate_type:     'federal',
                       newly_created: 'true'}
      @params = { id: @organization.id,
                  institution: { name: 'New Institution Name' },
                  pricing_setups: {blank_pricing_setup: pricing_setup} }

      put :update, params: @params, xhr: true
    end

    it 'should assign @attributes' do
      expect(assigns(:attributes).to_h.symbolize_keys).to eq(@params[:institution])
    end

    it 'should assign @organization' do
      expect(assigns(:organization)).to eq(@organization)
    end

    it 'should update the organization' do
      @organization.reload
      expect(@organization.name).to eq(@params[:institution][:name])
    end

    it 'should not save pricing setups' do
      expect(@organization.pricing_setups.count).to eq(0)
    end

    it 'should not set organization tags' do
      expect(assigns(:attributes)[:tag_list]).to be_nil
    end

    it { is_expected.to render_template "organizations/update" }
    it { is_expected.to respond_with :ok }
  end
end
