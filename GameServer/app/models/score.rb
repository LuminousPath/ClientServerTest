class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :completiontime
end
