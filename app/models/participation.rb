class Participation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :name
  attr_accessor :feedback
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
    # TODO - announce "submitted" to central server
  end
end