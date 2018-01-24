require 'rails/generators'

module Toronto

  class InstallGenerator < ::Rails::Generators::Base
    desc 'Copy BootstrapGenerators default files'
    source_root ::File.expand_path('../templates', __FILE__)

    class_option :template_engine
    class_option :stylesheet_engine
    class_option :skip_turbolinks, type: :boolean, default: false, desc: "Skip Turbolinks on assets"
    class_option :languages

    def copy_scaffold_generator
      directory 'lib/rails'
    end

    def copy_lib
      directory "lib/templates/#{options[:template_engine]}"
    end

    def copy_langs
      directory 'lib/templates/lang', 'lib/rails/generators/lang'
    end

    def copy_form_builder
      copy_file "form_builders/form_builder/_form.html.#{options[:template_engine]}", "lib/templates/#{options[:template_engine]}/scaffold/_form.html.#{options[:template_engine]}"
    end

    def create_layout
      # Remove the default layout.
      remove_file 'app/views/layouts/application.html.erb'
      # Create the new one.
      template "layouts/starter.html.#{options[:template_engine]}", "app/views/layouts/application.html.#{options[:template_engine]}"
    end

    def create_stylesheets
      stylesheet_extension = options[:stylesheet_engine] || 'css'

      copy_file "assets/stylesheets/starter.#{stylesheet_extension}", "app/assets/stylesheets/bootstrap-generators.#{stylesheet_extension}"
      copy_file 'assets/stylesheets/flags.css', 'app/assets/stylesheets/flags.css'
      copy_file 'assets/images/flags.png', 'app/assets/images/flags.png'

      if [:less, :scss].include?(options[:stylesheet_engine].to_sym)
        copy_file "assets/stylesheets/bootstrap-variables.#{stylesheet_extension}", "app/assets/stylesheets/bootstrap-variables.#{stylesheet_extension}"
      end
    end

    def copy_locales_controller
      copy_file 'controllers/locales_controller.rb', 'app/controllers/locales_controller.rb'
    end

    def patch_locale_files
      # TODO : use a template file
      data = %{
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
}
      inject_into_file 'app/controllers/application_controller.rb', data, :before => /^end/

      data = "\n  before_action :set_locale"
      inject_into_file 'app/controllers/application_controller.rb', data, :after => /^class ApplicationController < ActionController::Base/
    end

    def inject_locales_route
      p options
      langs = !options['languages'] || options['languages'].empty? ? 'en' : options['languages']
      langs_array = langs.split(',' )
      langs.gsub!( ',', '|' )

      # Create the routes for language management
      # This way lead to a lot of problem. We use ?locale=
      # route 'end'
      # route '  # Put all your routes inside the scope'
      # route "scope '(:locale)', locale: /#{langs}/ do"

      # Create the local file
      data = "I18n.config.load_path += Dir['#{Rails.root.to_s}/config/locales/**/*.{rb,yml}']\n\n"
      data << "I18n.config.available_locales = [ #{langs_array.map{ |e| ':'+e }.join( ', ' )} ]\n"
      data << "I18n.default_locale = :#{langs_array.first}"

      create_file 'config/initializers/locales.rb', data

      route "put 'set_locale/:locale', constraints: { locale: /#{langs}/ }, to: 'locales#set'"
    end

    # def disable_regular_routes_generation
    #   create_file 'config/initializers/generators.rb', 'Rails.application.config.generators.skip_routes = true'
    # end

    def inject_menu_helper
      # TODO : use a template file
      data = %{
def nav_link(link_text, link_path)
  class_name = current_page?(link_path) ? 'active' : ''

  content_tag(:li, :class => class_name) do
    link_to link_text, link_path
  end
end

}
      insert_into_file 'app/helpers/application_helper.rb', data, :before => /^end/
    end

    def inject_backbone
      application_js_path = 'app/assets/javascripts/application.js'

      if ::File.exists?(::File.join(destination_root, application_js_path))
        inject_into_file application_js_path, before: '//= require_tree' do
          "//= require bootstrap\n"
        end
      end
    end
  end

end
