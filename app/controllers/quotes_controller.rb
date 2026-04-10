class QuotesController < ApplicationController
  def show
    result = QuoteService::FetchByTag.call(tag: params[:tag])

    if result.success?
      render json: serialized_quotes(result.data)
    else
      render json: {
        message: "Cache sendo gerado para '#{params[:tag]}' Tente novamente em instantes."
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
