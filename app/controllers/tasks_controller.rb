class TasksController < AbstractSecurityController

  before_filter :set_user_story, :only => [:destroy, :assign, :claim, :renounce, :complete]
  before_filter :set_task, :only => [:destroy, :claim, :renounce, :complete]

  def renounce
    @task.team_members.delete(current_person)
    @task.save
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} renounced task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'renounce', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def claim
    @task.team_members << current_person
    @task.hours = 1
    @task.save
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} claimed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'claim', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def complete
    @task.update_attribute(:hours, 0)
    devs = @task.team_members.any? ? @task.team_members.map(&:name) : ["Nobody"]
    json = { :notification => "#{current_person.name} completed task of ##{@user_story.id}", :performed_by => current_person.name, :action => 'complete', :task_id => @task.id, :task_hours => @task.hours, :task_devs => devs, :user_story_status => @user_story.status, :user_story_id => @user_story.id }
    uid = Digest::SHA1.hexdigest("exclusiveshit#{@user_story.sprint_id}")
    Juggernaut.publish(uid, json)
  end

  def destroy
    @task.destroy && flash[:notice] = "Task deleted"
    redirect_to :back
  end

  private

  def truncate(string, length = 60)
    return string if string.length <= 60
    string[0...length-3] + "..."
  end
end
