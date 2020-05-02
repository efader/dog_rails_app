class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like, :claim]
  before_action :set_is_owner, only: [:show, :edit, :like, :destroy]
  before_action :only_permit_owner, only: [:edit, :destroy]
  before_action :set_upload_number, only: [:new, :edit]

  # GET /dogs
  # GET /dogs.json
  def index
    @permit_params = pagination_params

    @page = [params[:page].to_i, 1].max
    page_size = [params[:page_size].to_i, 5].max
    @num_pages = (Dog.all.size / page_size.to_f).ceil

    if (@sort_order = params[:sort_order]) == 'likes'
      @dogs = Like.where(created_at: (Time.now - 1.hours)..Time.now)
        .group('dog_id')
        .order('count(dog_id) desc')
        .limit(page_size)
        .offset((@page-1)*page_size)
        .collect{ |like| Dog.find(like.dog_id)}
    else
      @dogs = Dog.limit(page_size).offset((@page-1)*page_size)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @likes_this_dog = Like.where(dog_id: @dog.id, user_id: current_user&.id).any?
    @can_claim = user_signed_in? && !@dog.user_id
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        if params[:dog][:images].present?
          params[:dog][:images].each{ |i| @dog.images.attach(i) }
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    respond_to do |format|
      if user_signed_in? && !@is_owner
        like = Like.create(user_id: current_user.id, dog_id: @dog.id)
        format.html { redirect_to @dog, notice: 'Dog was successfully liked.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { redirect_to @dog, notice: 'Dog could not be liked.' }
        format.json { head :unprocessable_entity }
      end
    end
  end

  def claim
    respond_to do |format|
      if user_signed_in? && !@dog.user_id
        @dog.user_id = current_user.id
        if @dog.save
          format.html { redirect_to @dog, notice: 'Dog was successfully claimed.' }
          format.json { render :show, status: :accepted, location: @dog }
        else
          format.html { redirect_to @dog, notice: 'Dog could not be claimed.' }
          format.json { render json: @dog.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @dog, notice: 'Dog could not be claimed.' }
        format.json { head :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    def set_is_owner
      @is_owner = user_signed_in? && current_user.id.to_i == @dog&.user_id.to_i
    end

    def set_upload_number
      @upload_number = [params[:upload_number].to_i, 5].max
    end

    def only_permit_owner
      redirect_to @dog and return unless @is_owner
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end

    def pagination_params
      params.permit(:page, :page_size, :sort_order)
    end
end
