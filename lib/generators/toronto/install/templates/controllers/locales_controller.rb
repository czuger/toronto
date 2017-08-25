class LocalesController < ApplicationController

  def set
    # implement it this way : https://lingohub.com/frameworks-file-formats/rails5-i18n-ruby-on-rails/
    # Lead to a lot of problems

    return_to = request.referer

    I18n.locale = params[:locale] if params[:locale]
    # session[:locale] = params[:locale]

    redirect_to return_to + '?locale=' + I18n.locale.to_s
  end

end