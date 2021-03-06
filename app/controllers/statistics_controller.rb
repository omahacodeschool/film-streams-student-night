class StatisticsController < ApplicationController
	include StatisticsHelper
	before_filter :set_dates

	def index
	    @attendances = Attendance.count
		@unique_students = Attendance.all.group_by_year(:created_at).select(:student_id).distinct.count
		@unique_schools = Attendance.group_by_year('attendances.created_at').joins(:student => :school).select('schools.name').uniq.count
		@years = Event.all.map(&:date).map(&:year).uniq.sort
		@referrals = Referral.select('referrals.id').group('referrals.referral_type').count.transform_keys { |k| Referral.referral_types.key(k) }
	end

	def ruth_sokolof	
		@years_for_ruth_sokolof = Event.where(location: 0 ).map(&:date).map(&:year).uniq
		@location_stats = build_school_hash
		@referrals = Referral.select('referrals.id').group('referrals.referral_type').count.transform_keys { |k| Referral.referral_types.key(k) }
	end

	def dundee
		@years_for_the_dundee = Event.where(location: 1 ).map(&:date).map(&:year).uniq
		@location_stats = build_school_hash
		@referrals = Referral.select('referrals.id').group('referrals.referral_type').count.transform_keys { |k| Referral.referral_types.key(k) }

		if @location_stats['dundee']['students_grouped'].count == 0
			redirect_to :statistics, alert: "No statistics for the Dundee yet."
		end
	end

	def show
		@event_info = Event.find(params[:id])
		@events = Event.select(:id, :date).order(id: :desc)
		@event_years = Event.all.order(id: :desc).map(&:date).map(&:year).uniq
		@zipcodes = Student.joins(:attendances).select('students.zip').where("attendances.event_id = #{params[:id].to_i}").group(:zip).count
		@years = Student.joins(:attendances).select('students.year').where("attendances.event_id = #{params[:id].to_i}").group(:year).count.transform_keys { |k| Student.years.key(k) }
    	@schools = Student.joins(:attendances, :school).where("attendances.event_id = #{params[:id].to_i}").group("schools.name").count
		@movies = Movie.joins(:attendances).select('movies.title').where("attendances.event_id = #{params[:id].to_i}").group(:title).count
	    @referrals = Referral.get_referrals_by_event(params[:id])
    end

	def list
		@events = Event.order(date: :desc).map(&:date).uniq
		@event_years = Event.all.order(id: :desc).map(&:date).map(&:year).uniq
	end

	def attendance
		@attendances = Event.new.total_student_attendances
		@years = Event.all.map(&:date).map(&:year).uniq
	end

	def by_date
		@students = student_attends_by_year
		@schools = schools_name_by_year
	end

	def student
		@student = Student.find(params[:id])
	end
	
	def school
		@uniq_schools = uniq_schools_by_id(params[:id])
		@attendances= schools_by_id(params[:id])
		@school = School.find(params[:id])
	end
end