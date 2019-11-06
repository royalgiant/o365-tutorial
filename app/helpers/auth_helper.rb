module AuthHelper
  	# Scopes required by the app
  	SCOPES = [ 	'openid',
  				'email',
            	'profile',
            	'offline_access',
           		'User.Read',
            	'Mail.Read',
             	'Calendars.ReadWrite' ]

  	# Generates the login URL for the app.
  	def get_login_url
    	login_url = client.auth_code.authorize_url(:redirect_uri => authorize_url, :scope => SCOPES.join(' '))
  	end

  	# Exchanges an authorization code for a token
	def get_token_from_code(auth_code, resource)
	 	client.auth_code.get_token(auth_code,
	                                     :redirect_uri => authorize_url,
                                       :resource => resource,
	                                     :scope => SCOPES.join(' '))
	end

	# Gets the current access token
	def get_access_token(resource = "graph")
  		# Get the current token hash from session
	  	token_hash = resource == "graph" ? session[:graph_token] : session[:o365_token]

      if session[:graph_token].nil? || session[:graph_token]["resource"] == "https://outlook.office365.com"
        token_hash = session[:o365_token]
        token_hash["resource"] = "https://graph.microsoft.com"
        token = OAuth2::AccessToken.from_hash(client, token_hash)
      
        new_token = token.refresh!(:redirect_uri => authorize_url,
                                   :resource => token_hash["resource"],
                                   :scope => SCOPES.join(' '))
        session[:graph_token] = new_token.to_hash
        access_token = new_token.token
      else
  	  	token = OAuth2::AccessToken.from_hash(client, token_hash)

  	  	# Check if token is expired, refresh if so
  	  	if token.expired?
  	    	new_token = token.refresh!
  	    	# Save new token
          if resource == "graph" 
  	    	  session[:graph_token] = new_token.to_hash
          else
            session[:o365_token] = new_token.to_hash
          end
  	    	access_token = new_token.token
  	  	else
  	    	access_token = token.token
  	  	end
      end
	end

	def client
    @client ||= OAuth2::Client.new(
      	CLIENT_ID,
      	CLIENT_SECRET,
      	:site => 'https://login.microsoftonline.com',
      	:authorize_url => '/common/oauth2/authorize',
      	:token_url => '/common/oauth2/token'
    )
  end
end