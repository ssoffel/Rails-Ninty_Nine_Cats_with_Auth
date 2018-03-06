class CatsController < ApplicationController

  before_action :ensure_owner, only: [:create, :update, :new, :edit]


  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    render :edit
  end
  #Instead of using Cat.find, try searching for the cat
  # among only the current_user's cats with the
  #User#cats association. Remember, has_many associations
  #are lazy-loading and behave like scopes when you tack
  # query methods on the end. Doing this gives the added
  #security benefit of not even loading the cat if it
  #doesn't belong to the user.

  def update
    @cat = current_user.cats.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex, :user_id)
  end
end
