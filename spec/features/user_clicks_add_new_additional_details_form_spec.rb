require 'rails_helper'

RSpec.describe 'User clicks add new additional details form' do
  let_there_be_lane
  fake_login_for_each_test

  scenario 'successfully' do
    visit additional_details_path

    click_link 'Add new Additional Details Form'

    expect(current_path).to eq new_additional_detail_path
  end

  scenario 'successfully' do
    visit additional_details_path

    click_link 'Add new Additional Details Form'

    expect(page).to have_css 'h3.panel-title',
      text: 'Additional Details Form Creator'
  end
end

