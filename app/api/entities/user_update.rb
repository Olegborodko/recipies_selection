module Entities

  class UserUpdate < Grape::Entity
    expose :description, documentation: { type: 'string', values: ['I am fine, thanks'] }
  end

end