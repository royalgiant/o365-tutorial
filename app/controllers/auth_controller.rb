class AuthController < ApplicationController
  include AuthHelper

  def gettoken
    o365_token = get_token_from_code(params[:code], "https://outlook.office365.com")
    session[:o365_token] = o365_token.to_hash
  	redirect_to calendar_view_index_path
  end
end