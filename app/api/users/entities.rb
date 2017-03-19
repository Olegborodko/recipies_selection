module Users
  module Entities

    class UserCreate < Grape::Entity
      # expose :title, documentation: {type: 'string', desc: 'Title of the game', required: true}
      expose :email, documentation: { type: 'string', values: ['2@2.ru'] }
      expose :name, documentation: { type: 'string', values: ['Oleg'] }
      #expose :password, documentation: { type: 'string', values: ['111111'] }
      #expose :password_confirmation, documentation: { type: 'string', values: ['111111'] }
      expose :description, documentation: { type: 'string', values: ['I am fine, thanks'] }
      expose :message do |instance, options|
        options[:message]
        #instance.id
      end
      expose :token do |instance, options|
        options[:token]
      end
    end

    class UserUpdate < Grape::Entity
      expose :name, documentation: { type: 'string', values: ['Oleg'] }
      expose :description, documentation: { type: 'string', values: ['I am fine, thanks'] }
    end

  end
end