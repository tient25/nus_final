class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: [ :show ]

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
    @photos = @album.photos.order(created_at: :asc)
  end

  def new
    @album = current_user.albums.build
    @user_photos = current_user.photos.order(created_at: :desc)
    render layout: "profile"
  end

  def create
    # Check if album already exists
    @album = current_user.albums.find_by(title: album_params[:title])

    if @album.nil?
      # Create new album if it doesn't exist
      @album = current_user.albums.build(album_params)
      unless @album.save
        @user_photos = current_user.photos.order(created_at: :desc)
        render :new, status: :unprocessable_entity, layout: "profile"
        return
      end
    end

    # Handle single photo upload or selection
    photo_added = false

    if params[:album][:image].present?
      # Handle new photo upload
      photo = current_user.photos.build(
        image: params[:album][:image],
        title: "Photo from album #{@album.title}",
        sharing_mode: @album.sharing_mode
      )
      if photo.save
        @album.photos << photo unless @album.photos.include?(photo)
        photo_added = true
      end
    elsif params[:album][:photo_id].present?
      # Handle existing photo selection
      photo = current_user.photos.find_by(id: params[:album][:photo_id])
      if photo
        @album.photos << photo unless @album.photos.include?(photo)
        photo_added = true
      end
    end

    if photo_added
      redirect_to new_album_path
    else
      @user_photos = current_user.photos.order(created_at: :desc)
      render :new, status: :unprocessable_entity, layout: "profile"
    end
  end

  def edit
    puts current_user.albums.pluck(:id)
    puts "Editing album with ID: #{params[:id]}"
    @album = current_user.albums.find(params[:id])
    @user_photos = current_user.photos.order(created_at: :desc)
    render layout: "profile"
  end

  def update
    @album = current_user.albums.find(params[:id])

    # Handle photo removal (for direct removal)
    if params[:remove_photo_id].present?
      photo = @album.photos.find_by(id: params[:remove_photo_id])
      if photo
        @album.photos.delete(photo)
      end
      redirect_to edit_album_path(@album)
      return
    end

    # Handle batch photo removal from UI
    if params[:album][:remove_photo_ids].present?
      photo_ids = params[:album][:remove_photo_ids].split(",").map(&:to_i)
      photo_ids.each do |photo_id|
        photo = @album.photos.find_by(id: photo_id)
        @album.photos.delete(photo) if photo
      end
    end

    # Handle adding new photo
    if params[:album][:image].present?
      # Handle new photo upload
      photo = current_user.photos.build(
        image: params[:album][:image],
        title: "Photo from album #{@album.title}",
        sharing_mode: @album.sharing_mode
      )
      if photo.save
        @album.photos << photo unless @album.photos.include?(photo)
      end
      redirect_to edit_album_path(@album)
      return
    elsif params[:album][:photo_id].present?
      # Handle existing photo selection
      photo = current_user.photos.find_by(id: params[:album][:photo_id])
      if photo
        @album.photos << photo unless @album.photos.include?(photo)
      end
      redirect_to edit_album_path(@album)
      return
    end

    # Handle album info update
    if @album.update(album_params)
      redirect_to @album
    else
      @user_photos = current_user.photos.order(created_at: :desc)
      render :edit, status: :unprocessable_entity, layout: "profile"
    end
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    @album.destroy
    redirect_to user_albums_path(current_user), notice: "Album was successfully deleted."
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :description, :sharing_mode)
  end
end
