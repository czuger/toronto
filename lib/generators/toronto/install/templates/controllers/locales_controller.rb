class LocalesController < ApplicationController

  def set
    # implement it this way : https://lingohub.com/frameworks-file-formats/rails5-i18n-ruby-on-rails/
    # Lead to a lot of problems

    if params[:locale]
      I18n.locale = params[:locale]
      return_to = request.referer

      parsed_uri = URI.parse(return_to)
      params = parsed_uri.query ? CGI::parse( parsed_uri.query ) : {}
      params['locale'] = I18n.locale

      redirect_host = parsed_uri.scheme + '://' + parsed_uri.host
      redirect_host += ( ':' + parsed_uri.port.to_s ) if parsed_uri.port && parsed_uri.port != 80 && parsed_uri.port != 443
      redirect_host += parsed_uri.path

      redirect_host += ( '?' + URI.encode_www_form(params) )

      redirect_to redirect_host
    end
  end

end