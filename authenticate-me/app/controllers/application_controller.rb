class ApplicationController < ActionController::API
    before_action :snake_case_params


    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])# user whose `session_token` == token in `session` cookie
    end
      
      def login!(user)
        # debugger
        # reset `user`'s `session_token` and store in `session` cookie
        session[:session_token] = user.reset_session_token! 
        @current_user = user
        debugger
      end
      
      def logout!
        current_user.reset_session_token!# reset the `current_user`'s session cookie, if one exists
        session[:session_token] = nil# clear out token from `session` cookie
        @current_user = nil # so that subsequent calls to `current_user` return nil
      end
      
      def require_logged_in
        unless current_user
          render json: { message: 'Unauthorized' }, status: :unauthorized 
        end
      end


      def test
        if params.has_key?(:login)
          login!(User.first)
        elsif params.has_key?(:logout)
          logout!
        end
      
        if current_user
          render json: { user: current_user.slice('id', 'username', 'session_token') }
        else
          # debugger
          render json: ['No current user']
        end
      end

    private

    def snake_case_params
        params.deep_transform_keys!(&:underscore)
    end
end
