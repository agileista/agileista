class HipChatIntegration < ChatIntegration
  self.table_name = 'hip_chat_integrations'

  def required_fields_present?
    self.token.present? && self.room.present?
  end
end
