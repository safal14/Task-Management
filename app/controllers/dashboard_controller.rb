class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Temporary – just to see something
    @greeting = "Hello #{current_user.first_name}!"
  end
end
