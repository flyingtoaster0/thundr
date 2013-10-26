class Klass < ActiveRecord::Base
  belongs_to :section


  def start_time_twelve_hour
    start_time ? Time.parse(start_time).strftime('%l:%M%p') : ''
  end

  def end_time_twelve_hour
    end_time ? Time.parse(end_time).strftime('%l:%M%p') : ''
  end


  def day_full
    case day
      when 'M'
        'Monday'
      when 'T'
        'Tuesday'
      when 'W'
        'Wednesday'
      when 'Th'
        'Thursday'
      when 'F'
        'Friday'
    end
  end

end