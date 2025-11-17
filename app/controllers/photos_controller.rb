class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [ :show, :edit, :update, :destroy ]

  def new
    @photo = current_user.photos.build
    render layout: "profile"
  end

  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      redirect_to feeds_photos_path, notice: "Photo was successfully created."
    else
      render :new, layout: "posts", status: :unprocessable_entity
    end
  end

  def show
    render layout: "posts"
  end

  def edit
    # Only allow user to edit their own photos
    # redirect_to @photo unless @photo.user == current_user
    render layout: "profile"
  end

  def update
    # Only allow user to update their own photos
    redirect_to @photo unless @photo.user == current_user

    if @photo.update(photo_params)
      redirect_to @photo, notice: "Photo was successfully updated."
    else
      render :edit, layout: "profile", status: :unprocessable_entity
    end
  end

  def destroy
    # Only allow user to delete their own photos
    redirect_to feeds_photos_path unless @photo.user == current_user

    @photo.destroy
    redirect_to user_photos_path(current_user), notice: "Photo was successfully deleted."
  end

  def feeds
    if current_user.present?
      following_user_ids = current_user.followings.pluck(:id)
      user_ids_to_show = following_user_ids + [ current_user.id ]

      page = params[:page].to_i
      page = 1 if page < 1
      per_page = 6
      offset = (page - 1) * per_page

      @photos = Photo.joins(:user)
                    .where(user_id: user_ids_to_show, sharing_mode: true)
                    .includes(:user, :liked_users)
                    .order(publication_date: :desc, created_at: :desc)
                    .limit(per_page)
                    .offset(offset)

      @current_page = page
      @per_page = per_page
      @total_photos = Photo.joins(:user).where(user_id: user_ids_to_show, sharing_mode: true).count
      @has_more = (@current_page * @per_page) < @total_photos
    else
      @photos = Photo.none
      @has_more = false
    end

    render layout: "posts"
  end

  def discover
    @photos = Photo.joins(:user)
                  .where(sharing_mode: true)
                  .includes(:user, :liked_users)
                  .order("RANDOM()")
                  .limit(50)

    render layout: "posts"
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :image, :sharing_mode, :publication_date)
  end
end
