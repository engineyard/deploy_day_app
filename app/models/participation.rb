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
  
  def deployed!(host)
    begin
      participation = ParticipationResource.new(:host => host)
      participation.save!
      participation
    rescue Exception => e
    end
  end
  
  def announce!(user_id)
    begin
      participation = ParticipationResource.find(user_id)
      participation.name = name
      participation.feedback = feedback
      participation.save!
    rescue Exception => e
    end
  end
end