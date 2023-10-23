# frozen_string_literal: true

require 'rbconfig'

module TestProf
  module MemoryProf
    class Tracker
      module Rss
        class ProcFS
          def initialize
            @statm = File.open("/proc/#{$$}/statm", "r")
            @page_size = get_page_size
          end

          def track
            @statm.seek(0)
            @statm.gets.split(/\s/)[1].to_i * @page_size
          end

          private

          def get_page_size
            [
              -> { require 'etc'; Etc.sysconf(Etc::SC_PAGE_SIZE) },
              -> { `getconf PAGE_SIZE`.to_i },
              -> { 0x1000 }
            ].each do |strategy|
              page_size = begin
                strategy.call
              rescue StandardError
                next
              end
              return page_size
            end
          end
        end

        class PS
          def track
            `ps -o rss -p #{$$}`.strip.split.last.to_i * 1024
          end
        end

        class Wmic
          def track
            fetch.strip.split.last.to_i * 1024
          end

          private

          def fetch
            `wmic process where processid=#{$$} get WorkingSetSize`
          end
        end

        TOOLS = {
          linux: ProcFS,
          macosx: PS,
          unix: PS,
          windows: Wmic
        }

        class << self
          def tool
            TOOLS[os_type]&.new
          end

          def os_type
            case RbConfig::CONFIG['host_os']
            when /linux/
              :linux
            when /darwin|mac os/
              :macosx
            when /solaris|bsd/
              :unix
            when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
              :windows
            end
          end
        end
      end
    end
  end
end