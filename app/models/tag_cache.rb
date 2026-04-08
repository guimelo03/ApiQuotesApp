class TagCache
  include Mongoid::Document
  include Mongoid::Timestamps
  field :tag, type: String

  embeds_many :quotes
  before_validation :normalize_tag

  validates :tag, presence: true

  index({ tag: 1 }, { unique: true, background: true })

  def cached?
    persisted? && quotes.present?
  end

  private

  def normalize_tag
    self.tag = tag.to_s.downcase.strip.presence
  end
end
