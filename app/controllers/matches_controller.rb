class MatchesController < ApplicationController
  before_action :redirect_if_not_permission

  def index
    if current_user != nil
       @matches = Match.where(mentor_id: current_user.id) + Match.where(mentee_id: current_user.id)
    else
       @matches = Match.where(scheme_id: params[:scheme_id])
    end
  end


  def show
    @match = Match.find(params[:id])
  end

  def new
    @scheme_mentee = EnrollIn.where(role: "mentee", scheme_id: params[:scheme_id], matched: false)
    @scheme_mentor = EnrollIn.where(role: "mentor", scheme_id: params[:scheme_id])
    @match = Match.new
  end


   def create
     @match = Match.new
     @match.scheme_id = params[:scheme_id]
     @match.mentee_id = $mentee.user_id
     @match.mentor_id = $mentor.user_id

     # Save the questionnaire
     if @match.save
       # If save succeds, redirect to --
       flash[:alert]="Enrollment saved"
       inform_manual_match(@match)
       redirect_to request.referrer
     else
       # If save fails, redisplay the form so can fix problems
       flash[:alert]="Enrollment NOT saved"
       redirect_to request.referrer
     end
  end


   def match_mentees_to_mentors
    # Matching for all enrolled users is availble only when scheme has started
    if Scheme.find_by(id: params[:scheme_id]).startDate <= Date.current
       @mentees = EnrollIn.where( role: "mentee", matched:false).order(priority_score: :desc)
       @mentors = EnrollIn.where( role: "mentor")
       @mentees.each do |mentee|
          @mentors.each do |mentor|
             if mentee.matched
                if mentor.matched
                  @mentee_answers = Answer.find_by(user_id: mentee.user_id, scheme_id: params[:scheme_id]).user_answers
                  @mentor_answers = Answer.find_by(user_id: mentor.user_id , scheme_id: params[:scheme_id]).user_answers
                  @anwers_number = @mentor_answers.count

                  $ALL_ANSWERS_MATCH = false
                (0..@anwers_number -1).each do |n|

                      if @mentee_answers[n][1] == "true" && @mentor_answers[n][1] == "true"
                        if @mentee_answers[n] == @mentor_answers[n]
                           $ALL_ANSWERS_MATCH = true
                        else
                           $ALL_ANSWERS_MATCH = false
                        end
                      else if ( (@mentee_answers[n][1] == nil)  && (@mentor_answers[n][1]) ==nil )
                        if @mentee_answers[n] != @mentor_answers[n]
                           $ALL_ANSWERS_MATCH = true
                        else
                           $ALL_ANSWERS_MATCH = false
                        end
                      end
                  end
                  if $ALL_ANSWERS_MATCH
                    @match = Match.create(:mentee_id =>mentee.user_id , :mentor_id => mentor.user_id,:scheme_id=>  params[:scheme_id])

                    @match.save

                    mentee.matched = false
                    mentee.save
                    mentor.matched = false
                    mentor.save
                  end
                end
             end
          end
       end
     end

   # Inform all users that were matched
   inform_all_match(params[:scheme_id])
   flash[:info] = "Matching mentees to mentors is done."
  else
    # If scheme has not started yet, inform user
    flash[:alert] = "Sorry, scheme has not started yet, thus matching for all users is unavailable"
  end
   redirect_to matches_path(params[:scheme_id])
 end

   private
     def matches_params
        params.require(:match).permit(
          :mentor_id,
          :mentee_id,
          :scheme_id
        )
      end

      # Infrom all matched users in particular scheme about their matches (mentees/mentors)
      def inform_all_match(scheme_id)
        @matches = Match.where(scheme_id: scheme_id)
        @matches.each do |match|
          @mentee = User.find_by(id: match.mentee_id).username
          @mentor = User.find_by(id: match.mentor_id).username
          MatchMailer.inform_mentee_match(@mentee, @mentor).deliver
          MatchMailer.inform_mentor_match(@mentor, @mentee).deliver
        end
        flash[:alert] = "Matched mentors and mentees were successfully informed"
      end

      # Inform mentor, mentee about their match (used for single match/manual match)
      def inform_manual_match(match)
        @mentee = User.find_by(id: match.mentee_id).username
        @mentor = User.find_by(id: match.mentor_id).username
        MatchMailer.inform_mentee_match(@mentee, @mentor).deliver
        MatchMailer.inform_mentor_match(@mentor, @mentee).deliver
        flash[:alert] = "Matched mentor and mentee were successfully informed"
      end
end
