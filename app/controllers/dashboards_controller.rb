# require 'chartkick'
class DashboardsController < ApplicationController
  def index
    @orders = Order.all
  end
end
