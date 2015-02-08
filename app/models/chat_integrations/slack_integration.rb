class SlackIntegration < ChatIntegration
  self.table_name = 'slack_integrations'

  def required_fields_present?
    self.team.present? && self.token.present? && self.channel.present?
  end
end
