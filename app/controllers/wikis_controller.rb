class WikisController < ApplicationController
  def index
    @user_wikis = current_user.wikis
    @wikis = Wiki.public_wikis
   end

  def show
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to root_path
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      redirect_to root_path
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated."
      redirect_to root_path
    else
      flash[:error] = "There was an error updating the wiki. Please try again."
      redirect_to root_path
    end
  end

  def destroy
   @wiki = Wiki.find(params[:id])
   if @wiki.destroy
      flash[:notice] = "Wiki was deleted successfully."
      redirect_to root_path
   else
      flash[:error] = "There was an error deleting the wiki."
      redirect_to root_path
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end

end
