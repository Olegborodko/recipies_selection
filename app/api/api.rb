class Api < Grape::API

  mount Users::ApiUsersController
end