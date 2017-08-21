# Copyright © 2011-2017 MUSC Foundation for Research Development
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
<% if @errors %>
$("#modal_place #modal_errors").html("<%= escape_javascript(render( 'shared/modal_errors', errors: @errors )) %>")
<% elsif @in_dashboard %>
<% if notable_type_is_related_to_li_or_liv(@notable_type) %>
$("#modal_place").html("<%= escape_javascript(render( 'index', notable_id: @notable_id, notable_type: @notable_type, in_dashboard: @in_dashboard, notable: @notable )) %>")
$("span#<%= @selector %>").html("<%= escape_javascript(@notes.count.to_s) %>").addClass('blue-badge').siblings().removeClass("black-note").addClass("blue-note")
$('#notes-table').bootstrapTable()
<% else %>
$("#modal_place").html("<%= escape_javascript(render( 'index', notable_id: @notable_id, notable_type: @notable_type, in_dashboard: @in_dashboard, notable: @notable )) %>")
$("span#<%= @selector %>").html("<%= escape_javascript(@notes.count.to_s) %>")
$('#notes-table').bootstrapTable()
<% end %>
<% else %>
<% if notable_type_is_related_to_li_or_liv(@notable_type) %>
$("#modal_place").html("<%= escape_javascript(render( 'index', notable_id: @notable_id, notable_type: @notable_type, in_dashboard: @in_dashboard, notable: @notable )) %>")
$("span#<%= @selector %>").html("<%= escape_javascript(@notes.count.to_s) %>").addClass('blue-badge').siblings().removeClass("black-note").addClass("blue-note")
$('#notes-table').bootstrapTable()
<% else %>
$("#notes-table").bootstrapTable 'refresh', {silent: true}
$("#flashes_container").html("<%= escape_javascript(render( 'shared/flash' )) %>")
$("#modal_place").modal 'hide'
<% end %>
<% end %>
