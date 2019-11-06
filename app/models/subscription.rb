class Subscription < ActiveRecord::Base
  attr_accessor :body
  serialize :body, Hash
end
