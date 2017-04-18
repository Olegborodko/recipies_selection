module Entities

  class UserCreate < Entities::UserBase
    expose :message do |instance, options|
      options[:message]
      #instance.id
    end
    expose :token do |instance, options|
      options[:token]
    end
  end

end
