# frozen_string_literal: true

require "minitest/base_reporter"

module Minitest
  module TestProf
    class MemoryProfReporter < BaseReporter # :nodoc:
      attr_reader :tracker, :printer, :current_example

      def initialize(io = $stdout, options = {})
        super

        configure_profiler(options)

        @tracker = ::TestProf::MemoryProf.tracker(:minitest)
        @printer = ::TestProf::MemoryProf.printer(tracker)
      end

      def record(result)
        example = to_example(result)

        tracker.example_started(example, result)
        tracker.example_finished(example, result)
      end

      def start
        tracker.start
      end

      def report
        tracker.finish
        printer.print
      end

      private

      def to_example(result)
        {
          name: result.name.gsub(/^test_(?:\d+_)?/, ""),
          location: location_with_line_number(result)
        }
      end

      def location_with_line_number(result)
        File.expand_path(result.source_location.join(":")).gsub(Dir.getwd, ".")
      end

      def configure_profiler(options)
        ::TestProf::MemoryProf.configure do |config|
          config.mode = options[:mem_prof_mode]
          config.top_count = options[:mem_prof_top_count] if options[:mem_prof_top_count]
        end
      end
    end
  end
end
