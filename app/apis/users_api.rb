class UsersApi < Grape::API
  desc 'Get a list of users'
  params do
    optional :ids, type: String, desc: 'comma separated user ids'
  end
  get do
    users = User.filter(declared(params, include_missing: false))
    represent users, with: UserRepresenter
  end

  desc 'Create a user'
  params do
    requires :name, type: String, desc: 'Name of the user'
    requires :email, type: String, desc: 'Email of the user'
    requires :password, type: String, desc: 'Password of the user'
    requires :password_confirmation, type: String, desc: 'Password confirmation of the user'
  end

  post do
    user = User.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, user.errors.full_messages)) unless user.errors.empty?
    represent user, with: UserRepresenter
  end

  params do
    requires :id, desc: 'ID of the user'
  end
  route_param :id do
    desc 'Get a user'
    get do
      user = User.find(params[:id])
      represent user, with: UserRepresenter
    end

    desc 'Update a user'
    params do
    end
    put do
      # fetch user record and update attributes.  exceptions caught in app.rb
      user = User.find(params[:id])
      user.update_attributes!(declared(params, include_missing: false))
      represent user, with: UserRepresenter
    end
  end
end
