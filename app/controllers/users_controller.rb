class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    render json: params[:friend]
    
    # if params[:friend].present?
    #   @stock = Stock.new_lookup(params[:stock])

    #   if @stock
    #     respond_to do |format|
    #       format.js { render partial: 'users/result' }
    #     end
    #   else
    #     respond_to do |format|
    #       flash.now[:alert] = 'Please enter a valid symbol to search'
    #       format.js { render partial: 'users/result' }
    #     end
    #   end
    # else
    #   respond_to do |format|
    #     flash.now[:alert] = 'Please enter a symbol to search'
    #     format.js { render partial: 'users/result' }
    #   end
    # end
  end
end
