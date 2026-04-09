class Quote
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array

  embedded_in :tag_cache

  before_validation :normalize_fields

  validates :content, presence: true

  def as_json(options = {})
    super(only: [ :content, :author ])
  end

  private

  def normalize_fields
    self.content = content.to_s.strip
    self.author = author.to_s.strip.presence
    self.author_about.to_s.presence
  end
end
