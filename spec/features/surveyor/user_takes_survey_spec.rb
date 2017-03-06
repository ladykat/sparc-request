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
require 'timecop'

RSpec.describe 'User takes a survey', js: true do
  let_there_be_lane

  fake_login_for_each_test

  before :each do
    @survey   = create(:survey, title: "My Survey")
    @section  = create(:section, survey: @survey)
    org       = create(:organization)
    @ssr      = create(:sub_service_request_without_validations, organization: org)
  end

  scenario 'and sees all sections' do
    @section2 = create(:section, survey: @survey)

    visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
    wait_for_javascript_to_finish

    expect(all('.section').count).to eq(2)
  end



  context 'text questions' do
    scenario 'and sees text questions' do
      @q_text = create(:question, section: @section, question_type: 'text', content: 'Text Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_text.content)
      expect(page).to have_selector('.question input[type="text"]')
    end

    scenario 'and sees correctly saved value' do
      @q_text = create(:question, section: @section, question_type: 'text', content: 'Text Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: 'text value')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_text.id).content).to eq('text value')
    end
  end



  context 'textarea questions' do
    scenario 'and sees textarea questions' do
      @q_textarea = create(:question, section: @section, question_type: 'textarea', content: 'Textarea Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_textarea.content)
      expect(page).to have_selector('.question textarea')
    end

    scenario 'and sees correctly saved value' do
      @q_textarea = create(:question, section: @section, question_type: 'textarea', content: 'Textarea Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: 'textarea value')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_textarea.id).content).to eq('textarea value')
    end
  
  end
 


  context 'radio button questions' do
    scenario 'and sees radio button questions' do
      @q_radio_button = create(:question, section: @section, question_type: 'radio_button', content: 'Radio Button Question')
      @opt1           = create(:option, question: @q_radio_button, content: "Option 1")
      @opt2           = create(:option, question: @q_radio_button, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_radio_button.content)
      expect(page).to have_selector('.question input[type="radio"]', count: 2)
      expect(page).to have_selector('.option', text: @opt1.content)
      expect(page).to have_selector('.option', text: @opt2.content)
    end

    scenario 'and sees correctly saved value' do
      @q_radio_button = create(:question, section: @section, question_type: 'radio_button', content: 'Radio Button Question')
      @opt1           = create(:option, question: @q_radio_button, content: "Option 1")
      @opt2           = create(:option, question: @q_radio_button, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      first('input').click

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_radio_button.id).content).to eq('Option 1')
    end
  end



  context 'likert questions' do
    scenario 'and sees likert questions' do
      @q_likert = create(:question, section: @section, question_type: 'likert', content: "Likert Question")
      @opt1     = create(:option, question: @q_likert, content: "Option 1")
      @opt2     = create(:option, question: @q_likert, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_likert.content)
      expect(page).to have_selector('.option.likert-group div:first-child', text: '1')
      expect(page).to have_selector('.option.likert-group div:first-child', text: '2')
      expect(page).to have_selector('.option.likert-group .likert input[type="radio"]', count: 2)
      expect(page).to have_selector('.option.likert-group div', text: @opt1.content)
      expect(page).to have_selector('.option.likert-group div', text: @opt2.content)
    end

    scenario 'and sees correctly saved value' do
      @q_likert = create(:question, section: @section, question_type: 'likert', content: "Likert Question")
      @opt1     = create(:option, question: @q_likert, content: "Option 1")
      @opt2     = create(:option, question: @q_likert, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      first('input').click

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_likert.id).content).to eq('Option 1')
    end
  end



  context 'checkbox questions' do
    scenario 'and sees checkbox questions' do
      @q_checkbox = create(:question, section: @section, question_type: 'checkbox', content: 'Checkbox Question')
      @opt1       = create(:option, question: @q_checkbox, content: "Option 1")
      @opt2       = create(:option, question: @q_checkbox, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_checkbox.content)
      expect(page).to have_selector('.question input[type="checkbox"]', count: 2)
      expect(page).to have_selector('.option', text: @opt1.content)
      expect(page).to have_selector('.option', text: @opt2.content)
    end

    scenario 'and sees correctly saved value' do
      @q_checkbox = create(:question, section: @section, question_type: 'checkbox', content: 'Checkbox Question')
      @opt1       = create(:option, question: @q_checkbox, content: "Option 1")
      @opt2       = create(:option, question: @q_checkbox, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      all('input').each do |input|
        input.click
      end

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_checkbox.id).content).to eq('["Option 1", "Option 2"]')
    end
  end



  context 'yes/no questions' do
    scenario 'and sees yes/no questions' do
      @q_yes_no = create(:question, section: @section, question_type: 'yes_no', content: 'Yes/No Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_yes_no.content)
      expect(page).to have_selector('.option input[type="radio"]', count: 2)
      expect(page).to have_selector('.option', text: 'Yes')
      expect(page).to have_selector('.option', text: 'No')
    end

    scenario 'and sees correctly saved value' do
      @q_yes_no = create(:question, section: @section, question_type: 'yes_no', content: 'Yes/No Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      first('input').click

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_yes_no.id).content).to eq('yes')
    end
  end



  context 'email questions' do
    scenario 'and sees email questions' do
      @q_email = create(:question, section: @section, question_type: 'email', content: 'Email Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_email.content)
      expect(page).to have_selector('.question input[type="email"]')
    end

    scenario 'and sees correctly saved value' do
      @q_email = create(:question, section: @section, question_type: 'email', content: 'Email Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: 'email@email.email')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_email.id).content).to eq('email@email.email')
    end
  end



  context 'date questions' do
    scenario 'and sees date questions' do
      @q_date = create(:question, section: @section, question_type: 'date', content: 'Date Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_date.content)
      expect(page).to have_selector('.question .datetimepicker.date')
    end

    scenario 'and sees correctly saved value' do
      @q_date = create(:question, section: @section, question_type: 'date', content: 'Date Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      first('input').click

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_date.id).content).to eq(Date.today.strftime("%m/%d/%Y"))
    end
  end



  context 'number questions' do
    scenario 'and sees number questions' do
      @q_number = create(:question, section: @section, question_type: 'number', content: 'Number Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_number.content)
      expect(page).to have_selector('.question input[type="number"]')
    end

    scenario 'and sees correctly saved value' do
      @q_number = create(:question, section: @section, question_type: 'number', content: 'Number Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: '9000')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_number.id).content).to eq('9000')
    end
  end



  context 'zipcode questions' do
    scenario' and sees zipcode questions' do
      @q_zipcode = create(:question, section: @section, question_type: 'zipcode', content: 'Zipcode Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_zipcode.content)
      expect(page).to have_selector('.question input[type="text"]')
    end

    scenario 'and sees correctly saved value' do
      @q_zipcode = create(:question, section: @section, question_type: 'zipcode', content: 'Zipcode Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: '12345')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_zipcode.id).content).to eq('12345')
    end
  end



  context 'state questions' do
    scenario 'and sees state questions' do
      @q_state = create(:question, section: @section, question_type: 'state', content: 'State Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      find('.dropdown-toggle').click
      expect(page).to have_content(@q_state.content)
      expect(page).to have_selector('.question .bootstrap-select .dropdown-toggle')
      expect(page).to have_content('South Carolina')
    end

    scenario 'and sees correctly saved value' do
      @q_state = create(:question, section: @section, question_type: 'state', content: 'State Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      bootstrap_select('#response_question_responses_attributes_0_content', 'South Carolina')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_state.id).content).to eq('SC')
    end
  end



  context 'country questions' do
    scenario 'and sees country questions' do
      @q_country = create(:question, section: @section, question_type: 'country', content: 'Country Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      find('.dropdown-toggle').click
      expect(page).to have_content(@q_country.content)
      expect(page).to have_selector('.question .bootstrap-select .dropdown-toggle')
      expect(page).to have_content('United States')
    end

    scenario 'and sees correctly saved value' do
      @q_country = create(:question, section: @section, question_type: 'country', content: 'Country Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      bootstrap_select('#response_question_responses_attributes_0_content', 'United States')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_country.id).content).to eq('US')
    end
  end



  context 'time questions' do
    scenario 'and sees time questions' do
      @q_time = create(:question, section: @section, question_type: 'time', content: 'Time Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_time.content)
      expect(page).to have_selector('.question .datetimepicker.time')
    end

    scenario 'and sees correctly saved value' do
      @q_time = create(:question, section: @section, question_type: 'time', content: 'Time Question')
      time = Time.parse('2016-06-01 12:34:56')
      
      Timecop.freeze(time) do
        visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
        wait_for_javascript_to_finish

        first('input').click

        click_button 'Submit'
        wait_for_javascript_to_finish

        expect(Time.parse(QuestionResponse.find_by(question_id: @q_time.id).content).strftime("%I:%M %p")).to eq(time.strftime("12:00 AM"))
      end
    end
  end



  context 'phone questions' do
    scenario 'and sees phone questions' do
      @q_phone = create(:question, section: @section, question_type: 'phone', content: 'Phone Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_phone.content)
      expect(page).to have_selector('.question input[type="tel"]')
    end

    scenario 'and sees correctly saved value' do
      @q_phone = create(:question, section: @section, question_type: 'phone', content: 'Phone Question')

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      fill_in('response_question_responses_attributes_0_content', with: '123-456-7890')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_phone.id).content).to eq('123-456-7890')
    end
  end



  context 'dropdown questions' do
    scenario 'and sees dropdown questions' do
      @q_dropdown = create(:question, section: @section, question_type: 'dropdown', content: 'Dropdown Question')
      @opt1       = create(:option, question: @q_dropdown, content: "Option 1")
      @opt2       = create(:option, question: @q_dropdown, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_dropdown.content)
      expect(page).to have_selector('.question .bootstrap-select .dropdown-toggle')
    end

    scenario 'and sees correctly saved value' do
      @q_dropdown = create(:question, section: @section, question_type: 'dropdown', content: 'Dropdown Question')
      @opt1       = create(:option, question: @q_dropdown, content: "Option 1")
      @opt2       = create(:option, question: @q_dropdown, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      bootstrap_select('#response_question_responses_attributes_0_content', 'Option 1')

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_dropdown.id).content).to eq('Option 1')
    end
  end



  context 'multiple dropdown questions' do
    scenario 'and sees multiple dropdown questions' do
      @q_multiple_dropdown = create(:question, section: @section, question_type: 'multiple_dropdown', content: 'Multiple Dropdown Question')
      @opt1                = create(:option, question: @q_multiple_dropdown, content: "Option 1")
      @opt2                = create(:option, question: @q_multiple_dropdown, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      expect(page).to have_content(@q_multiple_dropdown.content)
      expect(page).to have_selector('.question select.selectpicker[multiple="multiple"]', visible: false)
      expect(page).to have_selector('.question .bootstrap-select .dropdown-toggle')
    end

    scenario 'and sees correctly saved value' do
      @q_multiple_dropdown = create(:question, section: @section, question_type: 'multiple_dropdown', content: 'Multiple Dropdown Question')
      @opt1                = create(:option, question: @q_multiple_dropdown, content: "Option 1")
      @opt2                = create(:option, question: @q_multiple_dropdown, content: "Option 2")

      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      bootstrap_multiselect('#response_question_responses_attributes_0_content', ['Option 1', 'Option 2'])

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(QuestionResponse.find_by(question_id: @q_multiple_dropdown.id).content).to eq('["", "Option 1", "Option 2"]')
    end
  end



  context 'and fills out the survey and submits' do
    scenario 'and is redirected to the completed screen' do
      visit new_surveyor_response_path(access_code: @survey.access_code, sub_service_request_id: @ssr.id)
      wait_for_javascript_to_finish

      click_button 'Submit'
      wait_for_javascript_to_finish

      expect(current_path).to eq(surveyor_response_complete_path(Response.last))
    end
  end
end
