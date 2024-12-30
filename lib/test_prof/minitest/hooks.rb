# frozen_string_literal: true

require "singleton"
require "test_prof/minitest/hooks/memory_prof"

module TestProf
  module Minitest
    class Hooks
      include Singleton

      HOOKS = {
        #event: EventProfHook,
        #fdoc: FactoryDoctorHook,
        mem_prof_mode: MemoryProfHook,
        #tag_prof: TagProfHook
      }.freeze

      attr_reader :hooks

      def initialize
        @hooks = HOOKS.map do |option, hook|
          hook.new if option
        end.compact
      end

      def setup(example)
        hooks.each { |hook| hook.setup(example) }
      end

      def teardown(example)
        hooks.each { |hook| hook.teardown(example) }
      end
    end
  end
end
