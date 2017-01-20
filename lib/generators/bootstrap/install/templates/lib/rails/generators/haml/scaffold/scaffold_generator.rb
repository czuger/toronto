require 'rails/generators/erb/scaffold/scaffold_generator'
require 'yaml'

module Haml
  module Generators
    class ScaffoldGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.expand_path("../templates", __FILE__)

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template "#{view}.html.haml", File.join("app/views", controller_file_path, filename)
        end

        languages = %w( en fr )

        languages.each do |lang|
          template "#{lang}.yml", File.join( 'config/locales', lang, "#{name.downcase.pluralize}.yml" )
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
              = nav_link( '#{name.humanize.pluralize}', #{name.underscore.pluralize}_path )}
        insert_into_file 'app/views/layouts/application.html.haml', data, :after => "= nav_link( 'Home', '#' )"
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
