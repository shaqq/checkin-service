class BusinessesApi < Grape::API
  desc 'Get a list of businesses'
  params do
    optional :ids, type: String, desc: 'comma separated business ids'
  end
  get do
    businesses = Business.filter(declared(params, include_missing: false))
    represent businesses, with: BusinessRepresenter
  end

  desc 'Create a business'
  params do
    requires :name, type: String, desc: 'Name of the business'
  end

  post do
    business = Business.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, business.errors.full_messages)) unless business.errors.empty?
    represent business, with: BusinessRepresenter
  end

  params do
    requires :id, desc: 'ID of the business'
  end
  route_param :id do
    desc 'Get a business'
    get do
      business = Business.find(params[:id])
      represent business, with: BusinessRepresenter
    end

    desc 'Update a business'
    params do
      optional :name, type: String, desc: 'Name of the business'
    end
    put do
      # fetch business record and update attributes.  exceptions caught in app.rb
      business = Business.find(params[:id])
      business.update_attributes!(declared(params, include_missing: false))
      represent business, with: BusinessRepresenter
    end

    desc 'Get a list of checkins for a business'
    get :checkins do
      business = Business.find(params[:id])
      checkins = Checkin.filter(business: business)
      represent checkins, with: CheckinRepresenter
    end

    desc 'Get a list of users that checked into the business'
    params do
      optional :unique, type: String, desc: 'Pass true if you want a unique set of users'
    end
    get :customers do
      business = Business.find(params[:id])
      users = business.users
      users = users.uniq if params[:unique]
      represent users, with: UserRepresenter
    end
  end
end
