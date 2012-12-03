# class ResponseTimer  
#   def initialize(app)  
#     @app = app  
#   end  
    
#   def call(env)  
#     status, headers, response = @app.call(env)  
#     [status, headers, ["<p>middleware!!</p>" + env["REMOTE_ADDR"] + response.body]] 
#   end  
# end  


# #Tutubnb2::Application.config.middleware.use "ResponseTimer"