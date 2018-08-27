class InvalidTimePeriod < StandardError
end

class TimePeriod
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish

    if finish <= start
      raise InvalidTimePeriod, 'finish time must be after start time'
    end
  end

  def intersection(time_period)
    return [] if no_time_period_intersection?(time_period)

    if contained_within_this?(time_period)
      [time_period.start, time_period.finish]
    elsif overlaps_this?(time_period)
      [start, finish]
    elsif ends_after_this_starts?(time_period)
      [start, time_period.finish]
    elsif starts_before_this_ends?(time_period)
      [time_period.start, finish]
    end
  end

  private

  def no_time_period_intersection?(time_period)
    time_period.finish <= start || time_period.start >= finish
  end

  def contained_within_this?(time_period)
    start <= time_period.start && finish >= time_period.finish
  end

  def overlaps_this?(time_period)
    start > time_period.start && finish < time_period.finish
  end

  def ends_after_this_starts?(time_period)
    start < time_period.finish && start >= time_period.start
  end

  def starts_before_this_ends?(time_period)
    finish > time_period.start && finish <= time_period.finish
  end
end