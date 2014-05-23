class User < ActiveRecord::Base
  include Napa::FilterByHash
end
