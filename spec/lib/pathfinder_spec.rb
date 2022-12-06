require './spec/spec_helper'

RSpec.describe Pathfinder do
  let(:result) { described_class.call(**args) }
  let(:args) { { lock:, excluded: } }
  let(:disks_count) { 3 }

  let(:lock) do
    CodeLock.new(
      secret_combination:,
      start_combination: [0, 0, 0],
      disks_count:,
      numbers_range:
    )
  end

  let(:secret_combination) { [1, 2, 2] }
  let(:numbers_range) { 0..2 }
  let(:excluded) do
    [
      [2, 0, 0],
      [1, 1, 1],
      [1, 1, 0]
    ]
  end

  describe '#call' do
    context 'with excluded' do
      let(:secret_combination) { [1, 1, 1] }
      let(:numbers_range) { 0..9 }
      let(:excluded) do
        [
          [0, 0, 9],
          [0, 9, 0],
          [8, 0, 0], # window
          [0, 0, 1],
          [0, 1, 0],
          [1, 0, 0]
        ]
      end

      it_behaves_like :tick_sequence
    end

    context 'with excluded' do
      it_behaves_like :tick_sequence

      context 'with fallback trick' do
        let(:secret_combination) { [2, 0, 1] }
        let(:excluded) do
          [
          [1, 0, 0],
          [1, 1, 1],
          [1, 1, 0],
          [0, 1, 0],
          [2, 0, 0]
          ]
        end


        it_behaves_like :tick_sequence
      end

      context 'with fallback trick' do
        let(:secret_combination) { [1, 2, 3] }
        let(:numbers_range) { 0..3 }
        let(:excluded) { [[1, 2, 2]] }

        it_behaves_like :tick_sequence
      end

      context 'with fallback trick' do
        let(:secret_combination) { [5, 2, 4] }
        let(:numbers_range) { 0..6 }
        let(:excluded) do
          [
            [0, 2, 3],
            [5, 2, 2],
            [5, 2, 3],
            [5, 2, 0]
          ]
        end

        it_behaves_like :tick_sequence
      end

      context 'with fallback trick' do
        let(:secret_combination) { [2, 2, 2] }
        let(:disks_count) { 3 }
        let(:numbers_range) { 0..2 }
        let(:excluded) do
          [
            [0, 2, 2],
            [0, 1, 2],
            [0, 0, 2],
            [0, 2, 1],
            [1, 2, 1],
            [2, 2, 1],
            [0, 1, 1],
            [0, 0, 1]
          ]
        end

        it_behaves_like :tick_sequence
      end

      context 'with fallback trick' do
        let(:secret_combination) { [0, 0, 3] }
        let(:numbers_range) { 0..4 }
        let(:excluded) do
          [
            [0, 0, 2],
            [0, 0, 4],
          ]
        end

        it_behaves_like :tick_sequence
      end
    end

    context 'when mission impossible' do
      context 'from the beginning' do
        let(:secret_combination) { [0, 0, 1] }
        let(:excluded) { [[0, 0, 1]] }

        it 'fails with error' do
          expect(result).to be_empty
        end
      end
    end
  end
end
