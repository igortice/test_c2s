class IndexController < ApplicationController
  before_action :check_is_logged
  def index
  end

  private

  def check_is_logged
    redirect_to tasks_path if current_user.present?
  end
end
