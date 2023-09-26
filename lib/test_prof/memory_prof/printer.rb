# frozen_string_literal: true

require "test_prof/memory_prof/printer/number_to_human"
require "test_prof/ext/string_truncate"

module TestProf
  module MemoryProf
    class Printer
      include Logging
      using StringTruncate

      def initialize(tracker)
        @tracker = tracker
      end

      def print
        messages = [
          "MemoryProf results\n\n",
          print_total,
          print_block("groups", tracker.groups),
          print_block("examples", tracker.examples)
        ]

        log :info, messages.join
      end

      private

      attr_reader :tracker

      def print_total
        if tracker.alloc?
          "Total allocations: #{tracker.total_memory}\n\n"
        else
          "Final RSS: #{number_to_human(tracker.total_memory)}\n\n"
        end
      end

      def print_block(name, items)
        return if items.empty?

        <<~GROUP
          Top #{tracker.top_count} #{name} (by #{tracker.mode}):

          #{print_items(items)}
        GROUP
      end

      def print_items(items)
        messages =
          items.map do |item|
            <<~ITEM
              #{item[:name].truncate(30)} (#{item[:location]}) – +#{memory_amount(item)} (#{memory_percentage(item)}%)
            ITEM
          end

        messages.join
      end

      def memory_amount(item)
        if tracker.rss?
          number_to_human(item[:memory])
        else
          item[:memory]
        end
      end

      def memory_percentage(item)
        (100.0 * item[:memory] / tracker.total_memory).round(2)
      end

      def number_to_human(value)
        NumberToHuman.convert(value)
      end
    end
  end
end
