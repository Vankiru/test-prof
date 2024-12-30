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
        @list = LinkedList.new(memory_at(:start))
      end

      def finish
        node = list.remove_node(:total, memory_at(:finish))
        @total_memory = node.total_memory
      end

      def example_started(example, result = nil)
        memory = memory_at(:start, result)

        list.add_node(example, memory)
      end

      def example_finished(example, result = nil)
        memory = memory_at(:finish, result)

        node = list.remove_node(example, memory)
        examples << node.to_hash(:total) if node
      end

      def group_started(group, result = nil)
        memory = memory_at(:start, result)
        list.add_node(group, memory)
      end

      def group_finished(group, result = nil)
        memory = memory_at(:finish, result)

        node = list.remove_node(group, memory)
        groups << node.to_hash(:hooks) if node
      end
    end

    class RspecTracker < Tracker
      attr_reader :meter

      def initialize(top_count)
        super

        @meter = MemoryProf.meter
      end

      private

      def memory_at(at, result = nil)
        meter.measure
      end
    end

    class MinitestTracker < Tracker
      def finish
        node = list.remove_node(:total, nil)
        @total_memory = node.nested_memory
      end

      private

      def memory_at(at, result = nil)
        return if result.nil?
        result.metadata.dig(:test_prof, :memory_prof, at)
      end
    end
  end
end
