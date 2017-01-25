require 'rails/generators'

module Toronto

  class InstallGenerator < ::Rails::Generators::Base
    desc 'Copy BootstrapGenerators default files'
    source_root ::File.expand_path('../templates', __FILE__)

    class_option :template_engine
    class_option :stylesheet_engine
    class_option :skip_turbolinks, type: :boolean, default: false, desc: "Skip Turbolinks on assets"

    def copy_scaffold_generator
      directory 'lib/rails'
    end

    def copy_lib
      directory "lib/templates/#{options[:template_engine]}"
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

    def copy_locale_files
      copy_file 'config/initializers/locales.rb', 'config/initializers/locales.rb'
      copy_file 'controllers/locales_controller.rb', 'app/controllers/locales_controller.rb'

      # TODO : use a template file
      data = %{
  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
}
      insert_into_file 'app/controllers/application_controller.rb', data, :before => /^end/

      data = "\n  before_action :set_locale"

      insert_into_file 'app/controllers/application_controller.rb', data, :after => /^class ApplicationController < ActionController::Base/
    end

    def inject_locales_route
      route = "\n  put 'set_locale/:locale', constraints: { locale: /en|fr/ }, to: 'locales#set'\n"
      insert_into_file 'config/routes.rb', route, :before => /^end/
    end

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
