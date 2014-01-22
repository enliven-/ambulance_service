class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def test
    render 'ambulances/test'
  end

  def tests
    render 'ambulances/tests'
  end

end
