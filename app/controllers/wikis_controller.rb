class WikisController < ApplicationController
  def index
    @user_wikis = current_user.wikis
    @wikis = Wiki.public_wikis
    authorize @wikis
   end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki    
  end

  def new
    @wiki = Wiki.new
    authorize @wiki    
  end

  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki    
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
     authorize @wiki    
 end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki    
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash[:error] = "There was an error updating the wiki. Please try again."
      render :edit
    end
  end

  def destroy
   @wiki = Wiki.find(params[:id])
    authorize @wiki    
   if @wiki.destroy
      flash[:notice] = "Wiki was deleted successfully."
      redirect_to wikis_path
   else
      flash[:error] = "There was an error deleting the wiki."
      redirect_to wikis_path
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end

end
