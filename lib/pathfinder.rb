# frozen_string_literal: true

class Pathfinder
  attr_accessor :sequence, :fails
  attr_reader :lock, :excluded

  def initialize(lock:, excluded:)
    @lock = lock
    @excluded = excluded
    @sequence = []
    @fails = 0

    raise MissionImpossible, 'No solution' if impossible?
  end

  def self.call(lock:, excluded:)
    pathfinder = new(lock:, excluded:)
    pathfinder.process
    pathfinder.sequence
  rescue MissionImpossible
    []
  end

  def process
    # если текущая комбинация не совпадает с конечной берем следующий диск
    until lock.unlocked?
      try_avoid unless resolve_disk
      lock.next_disk
    end
  end

  private

  def resolve_disk
    valid = true
    direction = find_direction
    # пока не найдем правильную цифру на диске
    valid = tick(direction) until lock.current_digit_correct? || !valid

    valid
  end

  def try_avoid
    # ищем комбинацию которая поможет обойти запрещенную и возвращаемся в то же место
    memo_disk = lock.current_disk
    lock.next_disk
    direction = find_direction

    until tick(direction)
      fail!
      lock.next_disk
    end

    self.fails = 0
    lock.current_disk = memo_disk
  end

  def fail!
    self.fails += 1
    raise MissionImpossible, 'No solution' if fails > lock.disks_count
  end

  def tick(direction)
    lock.send("#{direction}_digit")

    if current_combination_excluded?
      # eсли попадаем в запрещенную комбинацию - возвращаемся на шаг назад
      lock.send("#{backtrack(direction)}_digit")
      false
    else
      # если не попадаем - записываем комбинацию в последовательность
      sequence << lock.current_combination.dup
      true
    end
  end

  def backtrack(direction)
    direction == :next ? :prev : :next
  end

  def find_direction
    from = lock.current_digit
    to = lock.correct_digit

    lock.numbers_range.max / 2 > (to - from).abs ? :next : :prev
  end

  def current_combination_excluded?
    excluded.include?(lock.current_combination)
  end

  def impossible?
    excluded.include?(lock.secret_combination)
  end

  class MissionImpossible < StandardError; end
end

# tee0zed@gmail.com 32.11.2022
