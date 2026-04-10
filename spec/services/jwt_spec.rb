require "rails_helper"

RSpec.describe JsonWebToken do
  it "codifica e decodifica um token" do
    token = described_class.encode({ user_id: 1 })
    decoded = described_class.decode(token)

    expect(decoded[:user_id]).to eq(1)
  end

  it "retorna nil para token inválido" do
    expect(described_class.decode("token_invalido")).to be_nil
  end
end
