class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def feeds
    @albums = Album.where(sharing_mode: true)
                   .includes(:user, :photos, :liked_users)
                   .order(created_at: :desc)
                   .limit(20)

    render layout: "posts"
  end

  def discover
    @albums = Album.where(sharing_mode: true)
                   .includes(:user, :photos, :liked_users)
                   .order(Arel.sql("RANDOM()"))
                   .limit(20)

    render layout: "posts"
  end

  def show
    @album = Album.find(params[:id])
    @photos = @album.photos.order(created_at: :asc)
  end
end
