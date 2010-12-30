class ParticipationResource < ActiveResource::Base
  self.site = Rails.configuration.demo_day_server
  self.element_name = "participation"
end
class Participation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name
  attr_accessor :feedback
  
  validates_presence_of :name, :feedback
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def deployed!(user_id, env)
    # TODO - announce "deployed" to central server
  end
  
  def announce!(user_id, env)
    ParticipationResource.new(:name => name, :feedback => feedback).save!
  end
end