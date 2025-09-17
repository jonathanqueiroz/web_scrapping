class LogError
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :backtrace, type: String
  field :created_at, type: Time, default: -> { Time.now }
end
