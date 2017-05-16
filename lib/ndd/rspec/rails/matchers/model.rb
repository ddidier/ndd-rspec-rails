require_relative 'model/have_a_translated_attribute'
require_relative 'model/have_a_translated_error'
require_relative 'model/have_a_translated_model'

module Ndd
  module RSpec
    module Rails
      module Matchers
        # RSpec matchers for Rails models.
        module Model

          # Ensure that an attribute has an associated translation.
          #
          # More precisely, ensure that
          #   I18n.t(locale, "activerecord.attributes.{snake_case_class_name}.{snake_case_attribute_name}")
          # returns a value for the default locale (i.e. +I18n.default_locale+)
          # or all the available locales (i.e. +I18n.available_locales+).
          #
          # @example
          #
          #   RSpec.describe MyModel, type: :model do
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_attribute(:comment) }
          #     it { is_expected.to have_a_translated_attribute(:comment).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_attribute(:comment).in_default_locale }
          #   end
          #
          # @param attribute [String|Symbol] the attribute to test.
          # @return [Ndd::RSpec::Rails::Matchers::Model::HaveATranslatedAttribute]
          #
          def have_a_translated_attribute(attribute) # rubocop:disable Style/PredicateName
            HaveATranslatedAttribute.new(attribute)
          end

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
          # @example
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
          # @param error [String|Symbol] the error to test.
          # @return [Ndd::RSpec::Rails::Matchers::Model::HaveATranslatedError]
          #
          def have_a_translated_error(error) # rubocop:disable Style/PredicateName
            HaveATranslatedError.new(error)
          end

          # Ensure that a model has an associated translation.
          #
          # More precisely, ensure that
          #   I18n.t(locale, "activerecord.models.{snake_case_class_name}")
          # returns a value for the default locale (i.e. +I18n.default_locale+)
          # or all the available locales (i.e. +I18n.available_locales+).
          #
          # @example
          #
          #   RSpec.describe MyModel, type: :model do
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_model }
          #     it { is_expected.to have_a_translated_model.in_available_locales }
          #
          #     it { is_expected.to have_a_translated_model.in_default_locale }
          #   end
          #
          # @return [Ndd::RSpec::Rails::Matchers::Model::HaveATranslatedModel]
          #
          def have_a_translated_model # rubocop:disable Style/PredicateName
            HaveATranslatedModel.new
          end

        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Ndd::RSpec::Rails::Matchers::Model, type: :model
end
