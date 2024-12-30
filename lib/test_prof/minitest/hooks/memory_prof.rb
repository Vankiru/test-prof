# frozen_string_literal: true

require "test_prof/minitest/hooks/base"

module TestProf
  module Minitest
    class MemoryProfHook < BaseHook
      attr_reader :meter

      def initialize
        @meter = ::TestProf::MemoryProf.meter
      end

      def name
        :memory_prof
      end

      def setup(example)
        merge(example, { start: meter.measure })
      end

      def teardown(example)
        merge(example, { finish: meter.measure })
      end
    end
  end
end
