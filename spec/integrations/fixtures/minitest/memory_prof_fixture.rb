# frozen_string_literal: true

require "minitest/autorun"
require "test-prof"
require "securerandom"

describe "First Allocations" do
  it "allocates a few" do
    500.times.map { SecureRandom.hex }
    assert true
  end

  it "allocates some" do
    1000.times.map { SecureRandom.hex }
    assert true
  end

  it "allocates a lot" do
    10_000.times.map { SecureRandom.hex }
    assert true
  end
end

describe "Second Allocations" do
  it "allocates nothing" do
    assert true
  end

  it "allocates a bit" do
    100.times.map { SecureRandom.hex }
    assert true
  end
end
