# frozen_string_literal: true

require "test-prof"
require "securerandom"

describe "Examples allocations" do
  it "allocates a few" do
    500.times.map { SecureRandom.hex }
    expect(true).to eq true
  end

  it "allocates some" do
    1000.times.map { SecureRandom.hex }
    expect(true).to eq true
  end

  it "allocates a lot" do
    10_000.times.map { SecureRandom.hex }
    expect(true).to eq true
  end
end

describe "Groups Allocations" do
  context "with few allocations" do
    before(:context) do
      @array = 500.times.map { SecureRandom.hex }
    end

    it "does something with no allocations" do
      expect(true).to eq true
    end
  end

  context "with some allocations" do
    before(:context) do
      @array = 1000.times.map { SecureRandom.hex }
    end

    it "does something with few allocations" do
      expect(true).to eq true
    end
  end

  context "with many allocations" do
    before(:context) do
      @array = 10_000.times.map { SecureRandom.hex }
    end

    it "does something with many allocations" do
      expect(true).to eq true
    end
  end
end
