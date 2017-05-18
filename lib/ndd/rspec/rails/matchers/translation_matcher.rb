require 'active_support/core_ext/string/inflections'
require 'i18n'

module Ndd
  module RSpec
    module Rails
      module Matchers

        # Base class for matchers dealing with translation.
        class TranslationMatcher

          # Set the locales to test to +I18n.available_locales+.
          def initialize
            @tested_locales = I18n.available_locales
          end

          # Set the locales to test to all the available locales (i.e. +I18n.available_locales+).
          # @return self
          def in_available_locales
            @tested_locales = I18n.available_locales
            self
          end

          # Set the locales to test to the default locale (i.e. +I18n.default_locale+) only.
          # @return self
          def in_default_locale
            @tested_locales = [I18n.default_locale]
            self
          end

          # -------------------------------------------------------------------------------------------- private -----
          private

          # Convert an array of locales to a human readable list, i.e. ':en, :fr, :jp'.
          # @param locales [Array<String|Symbol>] the locales to convert.
          # @return [String] the converted locales.
          def locales_as_string(locales)
            locales.map { |locale| ":#{locale}" }.join(', ')
          end

          # Check that a translation exists for the given key in the given locale.
          # @param locale [Symbol] the locale of the translation to lookup.
          # @param key [String] the key of the translation to lookup.
          # @return [Boolean] true if a translation exists for the given key in the given locale, false otherwise.
          def translated?(locale, key)
            I18n.with_locale(locale) { I18n.translate!(key, fallback: false) }
            return true
          rescue I18n::MissingTranslationData
            return false
          end

        end

      end
    end
  end
end
