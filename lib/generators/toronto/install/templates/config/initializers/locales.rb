I18n.config.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]

I18n.config.available_locales = [ :en, :fr ]
I18n.default_locale = :en