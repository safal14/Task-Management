module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      @users = policy_scope(User).order(created_at: :desc)
      # later: .page(params[:page])
    end
  end
end