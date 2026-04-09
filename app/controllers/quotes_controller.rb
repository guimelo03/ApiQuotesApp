class QuotesController < ApplicationController
  def show
    tag = params[:tag]

    tag_cache = TagCache.find_by(tag: tag)

    if tag_cache&.cached?
      render json: serialized_quotes(tag_cache.quotes)
    else
      FetchQuotesJob.perform_later(tag)

      render json: {
        message: "Cache sendo gerado para '#{tag}' Tente novamente em instantes."
      }, status: :accepted
    end
  end

  private

  def serialized_quotes(quotes)
    {
      quotes: ActiveModelSerializers::SerializableResource.new(
        quotes,
        each_serializer: QuoteSerializer
      )
    }
  end
end
