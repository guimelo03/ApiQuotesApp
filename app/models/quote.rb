class Quote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :author, type: String
end
