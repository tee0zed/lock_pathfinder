RSpec.shared_examples_for :tick_sequence do
  let :lock do
    if defined?(super())
      super()
    else
      raise NotImplementedError, 'Please implement :lock to use :tick_sequence examples'
    end
  end

  let :result do
    if defined?(super())
      super()
    else
      raise NotImplementedError, 'Please implement :result to use :tick_sequence examples'
    end
  end

  let(:biggest_number) do
    first = lock.numbers_range.first
    last = lock.numbers_range.last

    (last - first).abs
  end

  it 'behaves like tick sequence' do
    result.each_cons(2) do |tick, next_tick|
      # валидный тик может быть или на 1 цифру или на разницу, если повернули с начальной точки в обратную сторону
      expect((tick.sum - next_tick.sum).abs).to eq(1).or eq(biggest_number)
    end

    # и должен содержать последней комбинацией успешную
    expect(result.last).to eq(lock.secret_combination)
  end
end
