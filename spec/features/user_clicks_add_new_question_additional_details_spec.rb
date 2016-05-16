require 'rails_helper'

RSpec.describe 'User clicks add new additional details form', js: true do
  let_there_be_lane
  fake_login_for_each_test

  scenario 'successfully' do
    visit new_additional_detail_path

    click_link 'Add Question'

    expect(page).to have_css 'h3.panel-title',
      text: 'Additional Details Form Creator'
  end
end

