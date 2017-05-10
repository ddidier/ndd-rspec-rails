require 'active_support/core_ext/string/inflections'
require 'i18n'
require 'ndd/rspec/rails/matchers/model/translation_matcher'

module Ndd
  module RSpec
    module Rails
      module Matchers
        module Model #:nodoc:

          # Ensure that an attribute has an associated translation.
          #
          # More precisely, ensure that
          #   I18n.t(locale, "activerecord.attributes.{snake_case_class_name}.{snake_case_attribute_name}")
          # returns a value for the default locale (i.e. +I18n.default_locale+)
          # or all the available locales (i.e. +I18n.available_locales+).
          #
          # For example:
          #
          #   RSpec.describe MyModel, type: :model do
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_attribute(:comment) }
          #     it { is_expected.to have_a_translated_attribute(:comment).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_attribute(:comment).in_default_locale }
          #   end
          #
          def have_a_translated_attribute(attribute) # rubocop:disable Style/PredicateName
            HaveATranslatedAttribute.new(attribute)
          end

          # ------------------------------------------------------------------------------------------------------------
          # Implements {#have_a_translated_attribute}.
          #
          class HaveATranslatedAttribute < TranslationMatcher

            # @param attribute [String|Symbol] the attribute to test.
            def initialize(attribute)
              super()
              @attribute = attribute
            end

            # @param model [Object] the model being tested.
            # @return [Boolean] true if the attribute has an associated translation, false otherwise.
            def matches?(model)
              @model = model
              @failed_locales = []
              @tested_locales.each do |tested_locale|
                @failed_locales << tested_locale unless translated?(tested_locale, translation_key)
              end
              @failed_locales.empty?
            end

            # @return [String] a description of this matcher.
            def description
              "have a translated attribute name for '#{@attribute}' in #{locales_as_string(@tested_locales)}"
            end

            # @return [String] details about the failure of this matcher.
            def failure_message
              message = ''
              message << "expected '#{@model.class}' to have a translated attribute name for '#{@attribute}'\n"
              message << "but the '#{translation_key}' key was not found\n"
              message << "for the locales: #{locales_as_string(@failed_locales)}"
              message
            end

            # -------------------------------------------------------------------------------------------- private -----
            private

            # @return [String] the translation key of the attribute.
            def translation_key
              model_key = @model.class.name.underscore
              attribute_key = @attribute.to_s
              "activerecord.attributes.#{model_key}.#{attribute_key}"
            end
          end

        end
      end
    end
  end
end
