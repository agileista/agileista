require 'rails_helper'

RSpec.describe ChatIntegration, type: :model do

  class MegaChat < ChatIntegration
    self.table_name = 'slack_integrations'
  end

  it 'should be an abstract class' do
    expect { ChatIntegration.new }.to raise_error(NotImplementedError)
  end

  it 'should force subclasses to define required_fields_present?' do
    expect { MegaChat.new.required_fields_present? }.to raise_error(NotImplementedError, 'required_fields_present? is not implemented')
  end
end
