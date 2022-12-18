class UserVerificationsController < ApplicationController

def new
end

def create
  @@email = params[:session][:email]
  pattern = /\A[\w+\-]+[.][\w+\-]+@kcl.ac.uk/i
  if (User.find_by(username: @@email)!= nil)
    flash.now[:danger] = "Please input a current unused KCL email"
    render('new')  
  else 
    if (@@email =~ pattern)
      @@number = 6.times.map{rand(0..9)}.join
      CodeMailer.new_code(@@number,@@email).deliver_now
      render('code')
    else
      flash.now[:danger] = "Please input email in firstname.lastname@kcl.ac.uk format"
      render('new')  
    end
  end
end

def newCode
  render 'code'
end

def requestCode
  @@number = 6.times.map{rand(0..9)}.join
  CodeMailer.new_code(@@number,@@email).deliver_now
  render('code')
end

def code
  @code = params[:session][:code]
  if @code == @@number.to_s
    redirect_to new_user_path(email: @@email)
  else
    flash.now[:danger] = "Invalid Code Submitted"
    # render 'verification'
  end
end


end
