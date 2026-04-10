class TagCache
  include Mongoid::Document
  include Mongoid::Timestamps
  field :tag, type: String

  embeds_many :quotes
  before_validation :normalize_tag

  validates :tag, presence: true

  index({ tag: 1 }, { unique: true, background: true })

  index({ updated_at: 1 }, { expire_after_seconds: 48.hours })

  def cached?
    persisted? && quotes.present? && updated_at > 12.hours
  end

  private

  def normalize_tag
    self.tag = tag.to_s.downcase.strip.presence
  end
end
