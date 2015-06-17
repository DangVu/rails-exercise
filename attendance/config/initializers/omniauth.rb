ENV["GOOGLE_KEY"] = '665615279693.apps.googleusercontent.com'
ENV["GOOGLE_SECRET"] = 'Zaop51nfutXXkN0zbVH4OVXw'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"],
          {
             :approval_prompt => "auto"
           }
end
OmniAuth.config.on_failure = SessionsController.action(:access_denied)