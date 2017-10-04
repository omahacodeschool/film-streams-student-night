# Every action in this controller has params[:event_id].

class StudentsController < ApplicationController
  before_filter :set_event

  # This is where user ends up if they're new to Film Streams!
  # We want to collect more info about them.
  # 
  # GET /events/1/students/new
  #             :event_id
  def new
    @student = Student.new(email: flash[:email])
  end

  # This is where user ends up if they've been to Film Streams before.
  # We're just asking them to verify our information about them.
  # 
  # GET /events/1/students/99
  #             :event_id  :id
  def edit
    @checkin = "true"
    @student = Student.find(params[:id])    
  end

  # The new-student form submits here.
  # If their profile is valid, forward them on to complete their attendance.
	def create
		@student = Student.new(student_params)
    if !params[:referrals] == nil
      params[:referrals].each do |referral_type|
        Referral.create!(
          :student_id => @student.id,
          :referral_type => referral_type.to_i
        )
      end 
    end

  	if @student.save
      @student.add_to_mailchimp

      flash[:student_id] = @student.id
      redirect_to new_event_attendance_path(params[:event_id])
    else
      render :new
    end
  end

  # The edit-student form submits here.
  # If their profile is valid, forward them on to complete their attendance.
  def update
    @student = Student.find(params[:id])


  # TODO: I want to write some code so that when a request is sent here, many things happen

  # If params[:referrals] is nil, I want to check to see if there are any referrals for that student already in the
  # database - If there are, I want to remove all of those entries.

  # If params[:referrals] is not nil, I want to get all of the referrals for that student_id from the database
  # If there are no referrals already, I want to add all of the referrals from params to the DB for the student.
  # If there are referrals already, I want store all of them. I then want to see if any of the entries match any of the params
  # If the referrals from the DB match the params, do nothing and discard those from memory.
  # If there are referrals from params that do not match any of the entries in the database, add them to the database
  # If there are referrals in the database, that do not match any of the params, remove them from the database.
    
    if @student.update_attributes(student_params)
      flash[:student_id] = @student.id
      redirect_to new_event_attendance_path(params[:event_id])
    else
      render :edit
    end
  end

  private

	def student_params
		params.require(:student).permit(:email, :name, :school_id, :year, :zip, :newsletter)
	end

  def set_event
    @event = Event.find(params[:event_id])
  end


end