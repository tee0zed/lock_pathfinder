# frozen_string_literal: true

class CodeLock
  attr_accessor :current_disk, :current_combination
  attr_reader :disks_count, :secret_combination, :start_combination, :numbers_range

  # @param [Integer] disks_count
  # @param [Array<Integer>] numbers_range
  # @param [Array<Integer>] start_combination
  # @param [Array<Integer>] secret_combination
  def initialize(secret_combination:, start_combination:, disks_count:, numbers_range:)
    @secret_combination = validate_and_set_combination!(secret_combination, numbers_range, disks_count)
    @current_combination = validate_and_set_combination!(start_combination, numbers_range, disks_count)
    @numbers_range = numbers_range
    @disks_count = disks_count
    @current_disk = 0
  end

  def next_disk
    self.current_disk = rotate!(current_disk, 0..disks_count - 1)
    self
  end

  def prev_disk
    self.current_disk = rotate_backwards!(current_disk, 0..disks_count - 1)
    self
  end

  def next_digit
    self.current_digit = rotate!(current_digit, numbers_range)
  end

  def prev_digit
    self.current_digit = rotate_backwards!(current_digit, numbers_range)
  end

  def current_digit_correct?
    current_digit.eql?(correct_digit)
  end

  def correct_digit
    secret_combination[current_disk]
  end

  def current_digit
    current_combination[current_disk]
  end

  def current_digit=(digit)
    current_combination[current_disk] = digit
  end

  def unlocked?
    current_combination.eql?(secret_combination)
  end

  def locked?
    !opened?
  end

  private

  def validate_and_set_combination!(combination, numbers_range, disks_count)
    raise ArgumentError, 'Combination is not an array' unless combination.is_a?(Array)
    raise ArgumentError, 'Combination is not of correct length' unless combination.length.eql?(disks_count)

    combination.each do |digit|
      raise ArgumentError, 'Combination is invalid' unless numbers_range.include?(digit)
    end
  end

  def rotate!(number, range)
    return range.first if number.next > range.last

    number.next
  end

  def rotate_backwards!(number, range)
    return range.last if number.pred < range.first

    number.pred
  end
end
