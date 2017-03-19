module Entities

  class UserUpdate < Grape::Entity
    expose :name, documentation: { type: 'string', values: ['Oleg'] }
    expose :description, documentation: { type: 'string', values: ['I am fine, thanks'] }
  end

end