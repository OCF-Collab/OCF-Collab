class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'testuser', password: 'SECUREpassword123;'
end
