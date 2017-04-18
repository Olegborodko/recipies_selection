module Entities

  class UserBase < Grape::Entity
    expose :email, documentation: {type: 'string', values: ['2@2.ru']}
    expose :name, documentation: {type: 'string', values: ['Oleg']}
    expose :description, documentation: {type: 'string', values: ['I am fine, thanks']}
    expose :status, documentation: {type: 'string', values: ['subscriber']}
  end
end