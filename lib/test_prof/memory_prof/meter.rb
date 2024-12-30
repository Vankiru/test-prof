# frozen_string_literal: true

require "test_prof/memory_prof/meter/rss_tool"

module TestProf
  module MemoryProf
    class Meter
      def initialize
        raise "Your Ruby Engine or OS is not supported" unless supported?
      end
    end

    class AllocMeter < Meter
      def measure
        GC.stat[:total_allocated_objects]
      end

      def supported?
        RUBY_ENGINE != "jruby"
      end
    end

    class RssMeter < Meter
      def initialize
        @rss_tool = RssTool.tool

        super
      end

      def measure
        @rss_tool.measure
      end

      def supported?
        !!@rss_tool
      end
    end
  end
end
