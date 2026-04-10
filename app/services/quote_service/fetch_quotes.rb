module QuoteService
  class FetchQuotes < ServiceBase
    def initialize(tag:)
      @tag = tag
      @uri = URI("https://quotes.toscrape.com/api/quotes")
    end

    def call
      fetch_quotes
    end

    attr_reader :tag, :uri

    private

    def fetch_quotes
      response = Net::HTTP.get_response(URI("#{uri}?tag=#{tag}&page=1"))
      return on_failure("Erro na requisição") unless response.is_a?(Net::HTTPSuccess)

      quote_data = JSON.parse(response.body)
      return on_failure("Nenhuma quote encontrada para #{tag}") if quote_data["quotes"].blank?

      tag_cache = TagCache.find_or_create_by(tag: tag)
      existing_content = tag_cache.quotes.map { |q| normalize(q.content) }

      quote_data["quotes"].each do |q|
        content = normalize(q["text"])
        next if existing_content.include?(content)

        author = q["author"]["name"]
        slug = q["author"]["slug"]
        tags = q["tags"]

        author_about_link = if slug.present?
          "https://quotes.toscrape.com/author/#{slug}"
        end

        tag_cache.quotes.create!(
          content: content,
          author: author,
          author_about: author_about_link,
          tags: tags
        )

        existing_content << content
      end

      on_success(tag_cache.quotes)
    rescue StandardError => e
      on_failure(e.message)
    end

    def normalize(text)
      text.to_s.downcase.strip
    end
  end
end
