# frozen_string_literal: true

number_regex = /\d+\.?\d{0,2}/
memory_human_regex = /#{number_regex}[KMGTPEZ]?B/
percent_regex = /#{number_regex}%/

describe "MemoryProf RSpec" do
  specify "with default options", :aggregate_failures do
    output = run_rspec("memory_prof", env: {"TEST_MEM_PROF" => "test"})

    expect(output).to include("MemoryProf results")
    expect(output).to match(/Final RSS: #{memory_human_regex}/)

    expect(output).to include("Top 5 groups (by RSS):")
    expect(output).to include("Top 5 examples (by RSS):")

    expect(output).to match(/with many allocations \(\.\/memory_prof_fixture.rb:44\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with some allocations \(\.\/memory_prof_fixture.rb:34\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with few allocations \(\.\/memory_prof_fixture.rb:24\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Groups Allocations \(\.\/memory_prof_fixture.rb:23\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Examples allocations \(\.\/memory_prof_fixture.rb:6\) – \+#{memory_human_regex} \(#{percent_regex}\)/)

    expect(output).to match(/allocates a lot \(\.\/memory_prof_fixture.rb:17\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates some \(\.\/memory_prof_fixture.rb:12\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates a few \(\.\/memory_prof_fixture.rb:7\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
  end

  specify "in RSS mode", :aggregate_failures do
    output = run_rspec("memory_prof", env: {"TEST_MEM_PROF" => "rss"})

    expect(output).to include("MemoryProf results")
    expect(output).to match(/Final RSS: #{memory_human_regex}/)

    expect(output).to include("Top 5 groups (by RSS):")
    expect(output).to include("Top 5 examples (by RSS):")

    expect(output).to match(/with many allocations \(\.\/memory_prof_fixture.rb:44\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with some allocations \(\.\/memory_prof_fixture.rb:34\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with few allocations \(\.\/memory_prof_fixture.rb:24\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Groups Allocations \(\.\/memory_prof_fixture.rb:23\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Examples allocations \(\.\/memory_prof_fixture.rb:6\) – \+#{memory_human_regex} \(#{percent_regex}\)/)

    expect(output).to match(/allocates a lot \(\.\/memory_prof_fixture.rb:17\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates some \(\.\/memory_prof_fixture.rb:12\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates a few \(\.\/memory_prof_fixture.rb:7\) – \+#{memory_human_regex} \(#{percent_regex}\)/)
  end

  specify "in allocations mode", :aggregate_failures do
    output = run_rspec("memory_prof", env: {"TEST_MEM_PROF" => "alloc"})

    expect(output).to include("MemoryProf results")
    expect(output).to match(/Total allocations: #{number_regex}/)

    expect(output).to include("Top 5 groups (by allocations):")
    expect(output).to include("Top 5 examples (by allocations):")

    expect(output).to match(/with many allocations \(\.\/memory_prof_fixture.rb:44\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with some allocations \(\.\/memory_prof_fixture.rb:34\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with few allocations \(\.\/memory_prof_fixture.rb:24\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Groups Allocations \(\.\/memory_prof_fixture.rb:23\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/Examples allocations \(\.\/memory_prof_fixture.rb:6\) – \+#{number_regex} \(#{percent_regex}\)/)

    expect(output).to match(/allocates a lot \(\.\/memory_prof_fixture.rb:17\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates some \(\.\/memory_prof_fixture.rb:12\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates a few \(\.\/memory_prof_fixture.rb:7\) – \+#{number_regex} \(#{percent_regex}\)/)
  end

  specify "with top_count", :aggregate_failures do
    output = run_rspec("memory_prof", env: {"TEST_MEM_PROF" => "alloc", "TEST_MEM_PROF_COUNT" => "3"})

    expect(output).to include("MemoryProf results")
    expect(output).to match(/Total allocations: #{number_regex}/)

    expect(output).to include("Top 3 groups (by allocations):")
    expect(output).to include("Top 3 examples (by allocations):")

    expect(output).to match(/with many allocations \(\.\/memory_prof_fixture.rb:44\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with some allocations \(\.\/memory_prof_fixture.rb:34\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/with few allocations \(\.\/memory_prof_fixture.rb:24\) – \+#{number_regex} \(#{percent_regex}\)/)

    expect(output).to match(/allocates a lot \(\.\/memory_prof_fixture.rb:17\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates some \(\.\/memory_prof_fixture.rb:12\) – \+#{number_regex} \(#{percent_regex}\)/)
    expect(output).to match(/allocates a few \(\.\/memory_prof_fixture.rb:7\) – \+#{number_regex} \(#{percent_regex}\)/)
  end
end
