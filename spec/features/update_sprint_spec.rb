require 'rails_helper'

RSpec.feature 'Updating a sprint', type: :feature do

  let(:user) { create_person }
  let(:project) { create_project(user) }
  let(:sprint) { create_sprint(project) }

  before do
    login_as(user)
  end

  it "updates a sprint" do
    visit "/projects/#{project.id}/sprints/#{sprint.id}/edit"
    fill_in 'Name', :with => 'My First Sprint'
    click_button 'Update Sprint'
    expect(page).to have_content 'Sprint saved'
  end

  it "fails to create a sprint" do
    visit "/projects/#{project.id}/sprints/#{sprint.id}/edit"
    fill_in 'Name', :with => ''
    click_button 'Update Sprint'
    expect(page).to have_content 'Sprint could not be saved'
  end
end
