module Entities

  class UserInfo < Grape::Entity
    expose :email, documentation: { type: 'string', values: ['2@2.ru'] }
    expose :name, documentation: { type: 'string', values: ['Oleg'] }
    expose :role, documentation: { type: 'string', values: ['subscriber'] } do |instance, options|
      instance.role.title
    end
    expose :description, documentation: { type: 'string', values: ['I am fine, thanks'] }
  end

end