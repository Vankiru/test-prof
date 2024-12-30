# frozen_string_literal: true

require "test_prof/minitest/hooks"

module TestProf
  module Minitest
    def before_setup
      super

      Hooks.instance.setup(self)
    end

    def after_teardown
      Hooks.instance.teardown(self)

      super
    end
  end
end
