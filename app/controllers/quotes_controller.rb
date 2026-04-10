class QuotesController < ApplicationController
  def show
    result = QuoteService::FetchByTag.call(tag: params[:tag])

    if result.success?
      render json: serialized_quotes(result.data)
    elsif result.errors = :processing
      render json: {
        message: "Cache sendo gerado para '#{params[:tag]}' Tente novamente em instantes."
      }, status: :accepted
    else
      render json: { error: result.errors }, status: :unprocessable_entity
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
