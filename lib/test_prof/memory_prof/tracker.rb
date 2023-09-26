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
        @list = LinkedList.new(track)
      end

      def finish
        node = list.remove_node(:total, track)
        @total_memory = node.total_memory
      end

      def example_started(example)
        list.add_node(example, track)
      end

      def example_finished(example)
        node = list.remove_node(example, track)
        examples << {**example, memory: node.total_memory}
      end

      def group_started(group)
        list.add_node(group, track)
      end

      def group_finished(group)
        node = list.remove_node(group, track)
        groups << {**group, memory: node.hooks_memory}
      end
    end

    class AllocTracker < Tracker
      def track
        GC.stat[:total_allocated_objects]
      end

      def mode
        "allocations"
      end

      def alloc?
        true
      end

      def rss?
        false
      end
    end

    class RssTracker < Tracker
      def track
        `ps -o rss -p #{Process.pid}`.strip.split.last.to_i * 1024
      end

      def mode
        "RSS"
      end

      def alloc?
        false
      end

      def rss?
        true
      end
    end
  end
end
