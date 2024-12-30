# frozen_string_literal: true

require "test_prof/memory_prof/tracker/linked_list"

module TestProf
  module MemoryProf
    # Tracker is responsible for tracking memory usage and determining
    # the top n examples and groups. There are two types of trackers:
    # AllocTracker and RssTracker.
    #
    # A tracker consists of four main parts:
    #  * list - a linked list that is being used to track memmory for individual groups/examples.
    #    list is an instance of LinkedList (for more info see tracker/linked_list.rb)
    #  * examples – the top n examples, an instance of Utils::SizedOrderedSet.
    #  * groups – the top n groups, an instance of Utils::SizedOrderedSet.
    #  * track - a method that fetches the amount of memory in use at a certain point.
    class Tracker
      attr_reader :top_count, :examples, :groups, :total_memory, :list

      def initialize(top_count)
        @top_count = top_count

        @examples = Utils::SizedOrderedSet.new(top_count, sort_by: :memory)
        @groups = Utils::SizedOrderedSet.new(top_count, sort_by: :memory)
      end

      def start
        @list = LinkedList.new(start_track)
      end

      def finish
        node = list.remove_node(:total, finish_track)
        @total_memory = node.total_memory
      end

      def example_started(id, example = id)
        list.add_node(id, example, start_track(id))
      end

      def example_finished(id)
        node = list.remove_node(id, finish_track(id))
        return unless node

        examples << {**node.item, memory: node.total_memory}
      end

      def group_started(id, group = id)
        list.add_node(id, group, start_track(id))
      end

      def group_finished(id)
        node = list.remove_node(id, finish_track(id))
        return unless node

        groups << {**node.item, memory: node.hooks_memory}
      end
    end

    class RspecTracker < Tracker
      attr_reader :meter

      def initialize(top_count)
        super

        @meter = MemoryProf.meter
      end

      private

      def start_track(example = nil)
        meter.measure
      end

      def finish_track(example = nil)
        meter.measure
      end
    end

    class MinitestTracker < Tracker
      private

      def start_track(example = nil)
        metadata(example, :start) if example
      end

      def finish_track(example = nil)
        metadata(example, :finish) if example
      end

      def metadata(example, value)
        example.metadata.dig(:test_prof, :memory_prof, value)
      end
    end
  end
end
