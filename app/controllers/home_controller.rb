class HomeController < ApplicationController
  def index
    redirect_to feeds_photos_path
  end
end
