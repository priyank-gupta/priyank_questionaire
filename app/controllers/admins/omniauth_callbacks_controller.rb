class Admins::OmniauthCallbacksController < ApplicationController

  def google_apps
    # You need to implement the method below in your model
    #p request.env["omniauth.auth"]['uid']
    p request.env["omniauth.auth"]
    
    @admin = Admin.find_for_googleapps_oauth(request.env["omniauth.auth"], current_admin)

    unless @admin
      redirect_to(login_index_url, :notice => 'Unauthorized Access')
    else
      session["devise.googleapps_data"] = @admin[:id]
      redirect_to questions_path
    end
  end
end
