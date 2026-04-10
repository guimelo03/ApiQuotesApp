RSpec.describe TagCache, type: :model do
  describe "#cached?" do
    let(:tag_cache) { TagCache.new(tag: "love") }

    before do
      tag_cache.quotes.build(content: "test", author: "test")
    end

    context "quando atualizado recentemente" do
      it "retorna true" do
        tag_cache.save!

        tag_cache.update!(updated_at: 1.hour.ago)

        expect(tag_cache.cached?).to be true
      end
    end

    context "quando está expirado" do
      it "retorna false" do
        tag_cache.updated_at = 13.hours.ago

        expect(tag_cache.cached?).to be false
      end
    end

    context "quando não tem quotes" do
      it "retorna false" do
        tag_cache.quotes.clear
        tag_cache.update!(updated_at: 1.hour.ago)

        expect(tag_cache.cached?).to be false
      end
    end
  end
end
