require "rails_helper"

RSpec.describe FetchQuotesJob do
  it "chama o service corretamente" do
    expect(QuoteService::FetchQuotes).to receive(:call).with(tag: "love")

    described_class.perform_now("love")
  end
end
