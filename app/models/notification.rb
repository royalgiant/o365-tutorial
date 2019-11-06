class Notification < ActiveRecord::Base
  attr_accessor :value
  serialize :value, Hash
end
