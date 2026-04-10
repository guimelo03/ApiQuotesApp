require "rails_helper"
require "net/http"

RSpec.describe QuoteService::FetchQuotes do
  let(:tag) { "love" }

  before do
    response = double(
      body: {
        "quotes" => [
          {
            "text" => "Text quote",
            "author" => { "name" => "Author", "goodreads_link" => "/author/test" },
            "tags" => [ "love" ]
          }
        ]
      }.to_json
    )

    allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

    allow(Net::HTTP).to receive(:get_response).and_return(response)
  end

  it "cria um TagCache com quotes" do
    result = described_class.call(tag: tag)

    expect(result.success?).to be true
    expect(TagCache.find_by(tag: tag)).to be_present
  end
end
