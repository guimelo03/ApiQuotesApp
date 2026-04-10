module QuoteService
  class FetchByTag < ServiceBase
    def initialize(tag:)
      @tag = tag
    end

    def call
      fetch_by_tag
    end

    attr_reader :tag

    private

    def fetch_by_tag
      tag_cache = TagCache.find_by(tag: tag)

      if tag_cache&.cached?
        on_success(tag_cache.quotes)
      else
        FetchQuotesJob.perform_later(tag)
        on_failure(:processing)
      end
    end
  end
end
