require 'rails/generators/erb/scaffold/scaffold_generator'
require 'yaml'

module Haml
  module Generators
    class ScaffoldGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.expand_path('../templates', __FILE__)

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template "#{view}.html.haml", File.join('app/views', controller_file_path, filename)
        end
      end

      def copy_and_update_languages_files

        languages = I18n.config.available_locales.map(&:to_s)
        # source_paths << File.expand_path('../rails/lang', __FILE__)
        source_paths << ::Rails.root + 'lib/rails/generators/lang'

        languages.each do |lang|
          yaml_path = File.join( 'config/locales', lang, "#{plural_table_name}.yml" )
          template "#{lang}.yml", yaml_path

          attributes_json = {}
          attributes.each do |attribute|
            attributes_json[ attribute.name ] = attribute.name.humanize
          end

          yaml_content = YAML.load( File.open( yaml_path ).read )
          yaml_content[ lang ][ 'helpers' ] = {}
          yaml_content[ lang ][ 'helpers' ][ 'label' ] = {}
          yaml_content[ lang ][ 'helpers' ][ 'label' ][ singular_table_name ] = attributes_json

          yaml_content[ lang ][ plural_table_name ][ 'menu_title' ] = name

          File.open( yaml_path, 'w' ) do |f|
            f.write( YAML.dump( yaml_content ) )
          end
        end
      end

      hook_for :form_builder, :as => :scaffold

      def copy_form_file
        if options[:form_builder].nil?
          filename = filename_with_extensions("_form")
          template "_form.html.haml", File.join("app/views", controller_file_path, filename)
        end
      end

      def add_menu
        data = %{
            %li
              = nav_link( t( '#{plural_table_name}.menu_title' ), #{plural_table_name}_path )}
        insert_into_file 'app/views/layouts/application.html.haml', data, :after => '%ul.nav.navbar-nav'
      end

      def resource_route
        inject_into_file 'config/routes.rb', "\n    resources :#{plural_table_name}",  after: /scope.*do/, verbose: false, force: false
      end

      protected

      def available_views
        %w(index edit show new)
      end

      def handler
        :haml
      end

    end
  end
end
