class HomeController < ApplicationController
  def hello
    @time = Time.now
  end
end
