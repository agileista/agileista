class ChatIntegration < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :project
  validates_presence_of :project_id

  def required_fields_present?
    raise NotImplementedError, "required_fields_present? is not implemented"
  end

  # "Sprint <a href=\"#{project_sprint_url(@project, @sprint)}\">##{@sprint.id}</a> <strong>#{event.to_s}</strong> by #{current_person.name}: \"#{@sprint.name}\"")
  # "Task <strong>#{event.to_s}</strong> on <a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> by #{current_person.name}: \"#{@task.definition}\""
  # "<a href=\"#{edit_project_user_story_url(@project, @user_story)}\">##{@user_story.id}</a> <strong>#{event.to_s}</strong> by #{current_person.name}: \"#{@user_story.definition}\""
  #
  # Sprint, Task, UserStory
  # link, event, person
  # object, link, person
  # object, link
end
