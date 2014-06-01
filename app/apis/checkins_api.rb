class CheckinsApi < Grape::API
  desc 'Get a list of checkins'
  params do
    optional :ids, type: String, desc: 'comma separated checkin ids'
    optional :user_id, type: String, desc: 'User ID to filter with'
    optional :business_id, type: String, desc: 'Business ID to filter with'
  end
  get do
    checkins = Checkin.filter(declared(params, include_missing: false))
    represent checkins, with: CheckinRepresenter
  end

  desc 'Create a checkin'
  params do
    requires :business_id, desc: 'ID of the business being checked into'
    requires :user_id, desc: 'ID of the user checking in'
  end

  post do
    checkin = Checkin.create(declared(params, include_missing: false))
    error!(present_error(:record_invalid, checkin.errors.full_messages)) unless checkin.errors.empty?
    represent checkin, with: CheckinRepresenter
  end

  params do
    requires :id, desc: 'ID of the checkin'
  end
  route_param :id do
    desc 'Get a checkin'
    get do
      checkin = Checkin.find(params[:id])
      represent checkin, with: CheckinRepresenter
    end

  end
end
