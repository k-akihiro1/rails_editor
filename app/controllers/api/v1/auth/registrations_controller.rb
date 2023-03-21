class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController

  private
    #ユーザー登録時に使用
    def sign_up_params
      params.require(:registration).permit(:name, :email, :password,:password_confirmation)
    end

    #ユーザー更新時に使用
    def account_update_params
      params.require(:registration).permit(:name, :email)
    end
end
