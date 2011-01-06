class ParticipationResource < ActiveResource::Base
  self.site = Rails.configuration.deploy_day_server
  self.element_name = "participation"
end
class Participation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name, :team_name
  attr_accessor :feedback
  
  validates_presence_of :team_name, :name, :feedback
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def deployed!(host)
    participation = ParticipationResource.new(:host => host)
    participation.save!
    participation.id
  end
  
  def announce!(user_id)
    participation = ParticipationResource.find(user_id)
    participation.name = name
    participation.team_name = team_name
    participation.feedback = feedback
    participation.save!
  end
end