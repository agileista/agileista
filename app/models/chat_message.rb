class ChatMessage
  attr_accessor :host

  attr_accessor :project
  attr_accessor :sprint
  attr_accessor :person

  def default_url_options
    { :host => 'app.agileista.local:3000' }
  end

  def initialize(host, params)
    self.host = host

    self.project = params[:project]
    self.sprint = params[:sprint]
    self.person = params[:person]
  end

  def sprint_event(event)
    "Sprint <a href=\"#{Rails.application.routes.url_helpers.project_sprint_url(project, sprint, host: host)}\">##{sprint.id}</a> <strong>#{event.to_s}</strong> by #{person.name}: \"#{sprint.name}\""
  end

  def sprint_created
    sprint_event(:created)
  end

  def sprint_updated
    sprint_event(:updated)
  end
end
