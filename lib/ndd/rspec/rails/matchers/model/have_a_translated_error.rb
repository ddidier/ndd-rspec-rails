require 'active_support/core_ext/string/inflections'
require 'i18n'
require 'ndd/rspec/rails/matchers/model/translation_matcher'

module Ndd
  module RSpec
    module Rails
      module Matchers
        module Model #:nodoc:

          # Ensure that an error on a model or an attribute has an associated translation.
          #
          # More precisely, ensure that (with all parameters being snake case) one of
          #   I18n.t(locale, "activerecord.errors.models.{class_name}.attributes.{attribute_name}.{error_key}")
          #   I18n.t(locale, "activerecord.errors.models.{class_name}.{error_key}")
          #   I18n.t(locale, "activerecord.errors.messages.{error_key}")
          #   I18n.t(locale, "errors.attributes.{attribute_name}.{error_key}")
          #   I18n.t(locale, "errors.messages.{error_key}")
          # returns a value for the default locale (i.e. +I18n.default_locale+)
          # or all the available locales (i.e. +I18n.available_locales+).
          #
          # For example:
          #
          #   RSpec.describe MyModel, type: :model do
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_error(:duplicate) }
          #     it { is_expected.to have_a_translated_error(:duplicate).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_error(:duplicate).in_default_locale }
          #
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_error(:duplicate).on_attribute(:comments) }
          #     it { is_expected.to have_a_translated_error(:duplicate).on_attribute(:comments).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_error(:duplicate).on_attribute(:comments).in_default_locale }
          #   end
          #
          def have_a_translated_error(message) # rubocop:disable Style/PredicateName
            HaveATranslatedError.new(message)
          end

          # ------------------------------------------------------------------------------------------------------------
          # Implements {#have_a_translated_error}.
          #
          class HaveATranslatedError < TranslationMatcher

            # @param error [String|Symbol] the error to test.
            def initialize(error)
              super()
              @error = error
            end

            # Set the attribute of the error to test.
            # @return self
            def on_attribute(attribute)
              @attribute = attribute
              self
            end

            # @param model [Object] the model being tested.
            # @return [Boolean] true if the error has an associated translation, false otherwise.
            def matches?(model)
              @model = model
              @failed_locales = []
              @tested_locales.each do |tested_locale|
                @failed_locales << tested_locale unless translated_in?(tested_locale)
              end
              @failed_locales.empty?
            end

            # @return [String] a description of this matcher.
            def description
              description = "have a translated error message for '#{@error}'"
              description << " on '#{@attribute}'" if @attribute.present?
              description << " in #{locales_as_string(@tested_locales)}"
              description
            end

            # @return [String] details about the failure of this matcher.
            def failure_message
              message = "expected '#{subject_as_string}' to have a translated error message for '#{@error}'\n"
              message << "but none of the following keys was found:\n"
              message << "#{translation_keys.map { |l| "  - #{l}" }.join("\n")}\n"
              message << "for the locales: #{locales_as_string(@failed_locales)}"
              message
            end

            # -------------------- private
            private

            # @return [String] a human readable string of the subject of the error, being a class or an attribute.
            def subject_as_string
              @attribute.present? ? "#{@model.class}##{@attribute}" : @model.class.to_s
            end

            def translation_keys
              @attribute.present? ? translation_keys_with_attribute : translation_keys_without_attribute
            end

            def translation_keys_with_attribute
              model_key = @model.class.name.underscore
              message_key = @error.to_s
              attribute_key = @attribute.to_s
              %W[
                activerecord.errors.models.#{model_key}.attributes.#{attribute_key}.#{message_key}
                activerecord.errors.models.#{model_key}.#{message_key}
                activerecord.errors.messages.#{message_key}
                errors.attributes.#{attribute_key}.#{message_key}
                errors.messages.#{message_key}
              ]
            end

            def translation_keys_without_attribute
              model_key = @model.class.name.underscore
              message_key = @error.to_s
              %W[
                activerecord.errors.models.#{model_key}.#{message_key}
                activerecord.errors.messages.#{message_key}
                errors.messages.#{message_key}
              ]
            end

            def translated_in?(tested_locale)
              translation_keys.each do |translation_key|
                return true if translated?(tested_locale, translation_key)
              end
              false
            end

          end

        end
      end
    end
  end
end
