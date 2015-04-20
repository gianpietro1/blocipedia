class CollaborationsController < ApplicationController
  
  def index
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @users = User.all - @wiki.users
    @collaborators = @wiki.collaborators
  end

  def create
    @wiki = Wiki.friendly.find(params[:wiki_id])
    @user = User.find_by_name(params[:search])
    if @wiki.users.include? @user 
      flash[:alert] = "User is already collaborating."
      redirect_to wiki_collaborations_path(@wiki)
    elsif @user == nil
      flash[:alert] = "User name does not exist."
      redirect_to wiki_collaborations_path(@wiki)
    else
      flash[:notice] = "Collaborators where updated."
        @collaboration = @wiki.collaborations.create(user_id: @user.id )           
      redirect_to wiki_collaborations_path(@wiki)
    end
  end

  def destroy
    @wiki = Wiki.friendly.find(params[:wiki_id])
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