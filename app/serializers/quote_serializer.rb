class QuoteSerializer < ActiveModel::Serializer
  attributes :quote, :author, :author_about, :tags

  def quote
    object.content
  end
end
