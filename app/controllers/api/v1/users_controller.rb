module Api
  module V1
    class UsersController < ApplicationController
      # GET /users ユーザー一覧所得（デバッグ用）
      def index
        @users = User.all
        render json: @users
      end

      def show
        @user = User.find_by(id: params[:id])
        render json: @user
      end
      
      def create
        #新規ユーザー登録

        if params[:pass1] === params[:pass2]
          @user = User.new(name: params[:name], email: params[:email], pass: params[:pass1])
          if @user.save
            @newuser = User.find_by(email: params[:email])
            # FlashMessage用の情報を含めてレスポンス
            @info = {
              name:@user.name,
              email:@user.email,
              flashMessage:true,
              mode:"processing",
              text:"ユーザー登録が完了しました"
            }
          elsif
            # 認証失敗時にはFlashMessage用の情報含めてレスポンス
            @info ={
            flashMessage: true,
            mode:"error",
            text:@user.errors.full_messages[0]
            }
          end
          render json: @info
        else
          #pathが違ったらパス１とパス２が違っている事を表すパラメターを持ってレスポンス
          @info = {
            flashMessage: false,
            passMatch: true
          }
          render json: @info
        end
      end
    end
  end
end
