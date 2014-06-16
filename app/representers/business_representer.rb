class BusinessRepresenter < Napa::Representer
  property :id, type: String
  property :name, type: String
  property :checkin_lock_time, type: Float
  property :created_at, type: String
end
