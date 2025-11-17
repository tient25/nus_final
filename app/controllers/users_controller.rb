class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [ :show, :photos, :albums, :following, :followers ]

  def new
  end

  def create
  end

  def show
    @photos = @user.photos.where(sharing_mode: true)
                         .includes(:user, :liked_users)
                         .order(created_at: :desc)
    @albums = @user.albums.where(sharing_mode: true)
                          .includes(:user, :liked_users)
                          .order(created_at: :desc)

    @photos_count = @user.photos.where(sharing_mode: true).count
    @albums_count = @user.albums.where(sharing_mode: true).count
    @following_count = @user.followings.count
    @followers_count = @user.followers.count

    render layout: "profile"
  end

  def photos
    @photos = @user.photos.where(sharing_mode: true)
                         .includes(:user, :liked_users)
                         .order(created_at: :desc)
    @photos_count = @user.photos.where(sharing_mode: true).count
    @albums_count = @user.albums.where(sharing_mode: true).count
    @following_count = @user.followings.count
    @followers_count = @user.followers.count

    render layout: "profile"
  end

  def albums
    @albums = @user.albums.where(sharing_mode: true)
                          .includes(:user, :liked_users)
                          .order(created_at: :desc)
    @photos_count = @user.photos.where(sharing_mode: true).count
    @albums_count = @user.albums.where(sharing_mode: true).count
    @following_count = @user.followings.count
    @followers_count = @user.followers.count

    render layout: "profile"
  end

  def following
    @following = @user.followings.includes(:photos, :albums)
    @photos_count = @user.photos.where(sharing_mode: true).count
    @albums_count = @user.albums.where(sharing_mode: true).count
    @following_count = @user.followings.count
    @followers_count = @user.followers.count

    render layout: "profile"
  end

  def followers
    @followers = @user.followers.includes(:photos, :albums)
    @photos_count = @user.photos.where(sharing_mode: true).count
    @albums_count = @user.albums.where(sharing_mode: true).count
    @following_count = @user.followings.count
    @followers_count = @user.followers.count

    render layout: "profile"
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
