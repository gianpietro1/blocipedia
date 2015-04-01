class CollaborationsController < ApplicationController
  
  def index
    @wiki = Wiki.find(params[:wiki_id])
    @users = User.all - @wiki.users
    @collaborators = @wiki.collaborators
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    if params[:user_ids]
      flash[:notice] = "Collaborators where updated."
      params[:user_ids].each do |user_id|
          @collaboration = @wiki.collaborations.create(user_id: user_id)        
      end
      redirect_to wiki_collaborations_path(@wiki)
    else
      flash[:warning] = "No collaborators where added."
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    if params[:user_ids]
      flash[:notice] = "Collaborators where updated."
      params[:user_ids].each do |user_id|
          @collaboration = @wiki.collaborations.find_by(user_id: user_id)
          @collaboration.destroy      
      end
      redirect_to wiki_collaborations_path(@wiki)
    else
      flash[:warning] = "No collaborators where removed."
      redirect_to @wiki
    end
  end

end