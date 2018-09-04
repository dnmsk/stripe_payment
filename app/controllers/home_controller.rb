class HomeController < ApplicationController
  public_access

  def index
    redirect_to payments_url if user_signed_in?
  end
end
