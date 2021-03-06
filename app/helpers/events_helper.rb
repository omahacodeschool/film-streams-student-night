module EventsHelper

	  # Database queries for reports
  def year_student_attendances(year)
    events = Event.by_year(year, field: :date)
    Attendance.where(event: events).select(:student_id).count
  end

  def attends_by_year_for_loc(year, location_id)
    Event.where(location: location_id).joins(:attendances).by_year(year).select(:student_id).count
  end

  def unique_student_attendances(year)
    events = Event.by_year(year, field: :date)
    Attendance.where(event: events).select(:student_id).uniq.count
  end

  def students_by_year_for_loc(year, location_id)
    # Event.where(location: location_id).joins(:attendances).by_year(year).select(:student_id).uniq.count
    Event.where(location: location_id).joins(:attendances => :student).by_year(year).select('students.id').uniq.count
  end

  def unique_schools(year)
    events = Event.by_year(year, field: :date)
    Attendance.where(event: events).joins(:student => :school).select('schools.name').uniq.count
  end

  def unique_schools_by_loc(year, location_id)
    Event.where(location: location_id).joins(:attendances => :student).by_year(year).select(:school_id).uniq.count
  end

  def school_by_event(event_id)
  	events = Attendance.where(event_id: event_id).joins(:student => :school).select('schools.name').uniq.count
  end

  def students_by_event(date)
    events = Attendance.by_day(date).joins(:student).select('students.id').uniq.count
  end

  def school_all_time_attendances
  	schools = Attendance.joins(:student => :school).group("schools.name").order("count_all DESC").count
  end

  def movies_by_event(event)
    movies = Movie.find_by(event_id: event.id)
  end

  def event_date(event)
    (Time.parse(event.date.to_s).strftime('%a, %b %d, %Y '))
  end

  def event_location(event)
    Event::LOCATIONS[event.location.to_sym][:title]
  end

  def event_logo(event)
    Event::LOCATIONS[event.location.to_sym][:logo]
  end

  def brand_colors(event)
    Event::LOCATIONS[event.location.to_sym][:brand_colors]
  end

  def theater_color_style(event)
    if @colors 
      return "background-color: #{brand_colors(event)}"
    end
  end
end
