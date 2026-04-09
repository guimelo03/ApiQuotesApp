require "rails_helper"

RSpec.describe "QuotesAPI", type: :request do
  let(:valid_token) { JsonWebToken.encode(user_id: 1) }
  let(:tag) { "love" }

  describe "GET /quotes/:tag" do
    context "quando NÃO autenticado" do
      it "retorna 401" do
        get "/quotes/#{tag}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "quando cache existe" do
      let(:quote) { Quote.new(content: "test", author: "test") }

      before do
        tag_cache = double("TagCache", cached?: true, quotes: [ quote ])
        allow(TagCache).to receive(:find_by).and_return(tag_cache)
      end

      it "retorna 200" do
        get "/quotes/#{tag}", headers: {
          "Authorization" => "Bearer #{valid_token}"
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context "quando cache não existe" do
      before do
        allow(TagCache).to receive(:find_by).and_return(nil)
      end

      it "retorna 202" do
        get "/quotes/#{tag}", headers: {
          "Authorization" => "Bearer #{valid_token}"
        }

        expect(response).to have_http_status(:accepted)
      end
    end
  end
end
