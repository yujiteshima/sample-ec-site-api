module Api
  module V1
    class AuthsController < ApplicationController
      def index
      @auth = User.find_by(email: params[:email], pass: params[:pass])
        if @auth == nil
          @authFlg = false
          @message = {
          authFlg: @authFlg,
          mode: "error",
          text: "認証失敗しました"
          }
        else
          @authFlg= true
            @message = {
        authFlg: @authFlg,
        name: @auth.name,
        email: @auth.email,
        pass: @auth.pass,
        mode: @mode,
        }
        end
      render json: @message
      end
    end
  end
end