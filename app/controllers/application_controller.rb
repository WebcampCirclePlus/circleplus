class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :name_kanji ,:name_kana, :phone_number ,:postal_code ,:address])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name, :name_kanji ,:name_kana, :phone_number, :postal_code, :address])
  end

end
