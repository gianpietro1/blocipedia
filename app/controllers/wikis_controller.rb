class WikisController < ApplicationController

  def index
    @user_wikis = current_user.wikis
    @wikis = Wiki.public_wikis.search(params[:search]).paginate(:per_page => 5, :page => params[:page])
    authorize @wikis
   end

  def show
    @wiki = Wiki.friendly.find(params[:id])
    if request.path != wiki_path(@wiki)
      redirect_to @wiki, status: :moved_permanently
    end
    authorize @wiki    
  end

  def new
    @wiki = Wiki.new
    authorize @wiki    
  end

  def create
    @wiki = Wiki.create(wiki_params)
    @wiki.user_id = current_user.id
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
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki    
 end

  def update
    @wiki = Wiki.friendly.find(params[:id])
    authorize @wiki    
    if @wiki.update_attributes(wiki_params)
      if (@wiki.public? && @wiki.collaborators.any?)
       @wiki.collaborations.each do |collaboration|
         if collaboration.user_id != @wiki.user.id
           collaboration.destroy
         end
      end
    end
     flash[:notice] = "Wiki was updated."
     redirect_to @wiki
    else
      flash[:error] = "There was an error updating the wiki. Please try again."
      render :edit
    end
  end

  def destroy
   @wiki = Wiki.friendly.find(params[:id])
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
    params.require(:wiki).permit(:title, :body, :private, :all_tags)
  end


end
