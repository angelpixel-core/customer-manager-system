# frozen_string_literal: true

require "spec_helper"

RSpec.describe CustomerCore::Domain::Customer do
  it "creates a valid customer" do
    customer = described_class.new(name: "Angel", email: "test@mail.com")
    expect(customer.email).to eq("test@mail.com")
  end
  it "fails without email" do
    expect {
      described_class.new(name: "Angel", email: nil)
    }.to raise_error(ArgumentError)
  end
end
