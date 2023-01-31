class Api::SessionsController < ApplicationController
  def show
     @user = current_user 
     if @user 
        render 'api/@user/show'
     else 
        render json: {'user: nil'}
     end
  end

  def create
  end

  def destroy
  end
end
