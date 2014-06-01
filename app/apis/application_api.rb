class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount UsersApi => '/users'
  mount BusinessesApi => '/businesses'

  add_swagger_documentation
end
