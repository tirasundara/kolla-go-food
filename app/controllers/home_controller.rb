class HomeController < ApplicationController
  def hello
    @today = Date.today
    @users = User.all
    # @request = request
    # @response = response
  end

  def goodbye
    @tomorrow = Date.today + 1.day
  end
end
