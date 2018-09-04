class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, if: :use_devise_auth?

private

  def self.public_access
    @public_access = true
  end

  def public_access?
    self.class.instance_variable_get(:@public_access)
  end

  def use_devise_auth?
    !(devise_controller? || public_access?)
  end

end
