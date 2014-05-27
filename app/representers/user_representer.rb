class UserRepresenter < Napa::Representer
  property :id, type: String
  property :name, type: String
  property :email, type: String
  property :created_at, type: String
end
