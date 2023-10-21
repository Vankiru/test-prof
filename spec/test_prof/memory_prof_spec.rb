# frozen_string_literal: true

describe TestProf::MemoryProf do
  subject { described_class }

  describe ".config" do
    let(:config) { subject.config }

    it "returns an instance of TestProf::MemoryProf::Configuration" do
      expect(config).to be_kind_of(TestProf::MemoryProf::Configuration)
    end

    describe "#mode=" do
      let(:set_mode) { config.mode = value }
      
      context "when value is alloc" do
        let(:value) { "alloc" }

        it "sets mode to alloc" do
          set_mode

          expect(config.mode).to eq(:alloc)
        end
      end

      context "when value is rss" do
        let(:value) { "rss" }

        it "sets mode to rss" do
          set_mode

          expect(config.mode).to eq(:rss)
        end
      end

      context "when value is neither alloc or rss" do
        let(:value) { "invalid" }

        it "sets mode to alloc" do
          set_mode

          expect(config.mode).to eq(:rss)
        end
      end
    end

    describe "#top_count=" do
      let(:set_top_count) { config.top_count = value }

      context "when value is an integer" do
        let(:value) { 5 }

        it "sets top_count to the value" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end

      context "when value is a float" do
        let(:value) { 5.7 }

        it "transforms the value to an integer" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end

      context "when value is 0" do
        let(:value) { 0 }

        it "sets top_count to 5" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end

      context "when value is negative" do
        let(:value) { -7 }

        it "sets top_count to 5" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end

      context "when value is nil" do
        let(:value) { nil }

        it "sets top_count to 5" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end

      context "when value is a text" do
        let(:value) { "invalid" }

        it "sets top_count to 5" do
          set_top_count

          expect(config.top_count).to eq(5)
        end
      end
    end
  end

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