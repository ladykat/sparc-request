# Copyright © 2011-2016 MUSC Foundation for Research Development
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

require "rails_helper"
RSpec.describe Dashboard::ApplicationHelper do
  describe "#display_if" do
    context "arguments are equal" do
      it "should return 'display: block;'" do
        expect(display_if(true)).to eq(style: "display: block;")
        expect(display_if("abc", "abc")).to eq(style: "display: block;")
      end
    end

    context "arguments are not equal" do
      it "should return 'display: none;'" do
        expect(display_if(false)).to eq(style: "display: none;")
        expect(display_if("abc", "def")).to eq(style: "display: none;")
      end
    end
  end

  describe "#display_user_role" do
    context "ProjectRole has role 'other'" do
      it "should return role_other" do
        expect(display_user_role(ProjectRole.new(role: "other", role_other: "Resident"))).to eq("Resident")
      end
    end

    context "ProjectRole does not have role 'other'" do
      it "should return humanized role" do
        expect(display_user_role(ProjectRole.new(role: "staff-scientist"))).to eq("Staff-scientist")
      end
    end
  end
end
