# frozen_string_literal: true

describe TestProf::MemoryProf do
  subject { described_class }

  describe ".tracker" do
    context "when mode is alloc" do
      before { described_class.config.mode = "alloc" }

      it "returns an instance of AllocTracker" do
        expect(subject.tracker).to be_kind_of(TestProf::MemoryProf::AllocTracker)
      end

      it "sets tracker.top_count to config.top_count" do
        expect(subject.tracker.top_count).to eq(5)
      end
    end

    context "when mode is rss" do
      before { described_class.config.mode = "rss" }

      it "returns an instance of RssTracker" do
        expect(subject.tracker).to be_kind_of(TestProf::MemoryProf::RssTracker)
      end

      it "sets tracker.top_count to config.top_count" do
        expect(subject.tracker.top_count).to eq(5)
      end
    end
  end
end
