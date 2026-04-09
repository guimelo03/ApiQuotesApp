class FetchQuotesJob < ApplicationJob
  queue_as :default

  def perform(tag)
    QuoteService::FetchQuotes.call(tag: tag)
  end
end
