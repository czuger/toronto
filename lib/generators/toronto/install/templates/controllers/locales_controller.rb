class LocalesController < ApplicationController

  def set
    # TODO : implement it this way : https://lingohub.com/frameworks-file-formats/rails5-i18n-ruby-on-rails/

    session[:return_to] ||= request.referer

    # I18n.locale = params[:locale] || I18n.default_locale
    session[:locale] = params[:locale]

    redirect_to session.delete(:return_to)
  end

end