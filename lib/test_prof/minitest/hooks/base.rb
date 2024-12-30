# frozen_string_literal: true

module TestProf
  module Minitest
    class BaseHook
      private

      def merge(example, data)
        example.metadata[:test_prof] ||= {}
        example.metadata[:test_prof][name] ||= {}

        example.metadata[:test_prof][name].merge!(data)
      end
    end
  end
end
