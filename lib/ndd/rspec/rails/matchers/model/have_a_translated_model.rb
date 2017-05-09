require 'active_support/core_ext/string/inflections'
require 'i18n'

module Ndd
  module RSpec
    module Rails
      module Matchers
        module Model

          # Ensures that a model has a translated name. For example:
          #
          #   RSpec.describe MyModel, type: :model do
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_model }
          #     it { is_expected.to have_a_translated_model.in_all_available_locales }
          #
          #     it { is_expected.to have_a_translated_model.in_default_locale }
          #   end
          #
          def have_a_translated_model
            HaveATranslatedModel.new
          end

          # ------------------------------------------------------------------------------------------------------------
          # Implements #have_a_translated_model.
          #
          class HaveATranslatedModel

            def matches?(model)
              @model = model
              @tested_locales ||= I18n.available_locales
              @failed_locales = []

              @tested_locales.each do |tested_locale|
                I18n.with_locale(tested_locale) do
                  begin
                    I18n.t(model_name_key, raise: true)
                  rescue I18n::MissingTranslationData
                    @failed_locales << tested_locale
                  end
                end
              end

              @failed_locales.empty?
            end

            def description
              'have a translated model name'
            end

            def failure_message
              message = ''
              message << "expected '#{@model.class}' to have a translated model name\n"
              message << "but the '#{model_name_key}' key was not found\n"
              message << "for the locales: #{@failed_locales.map { |l| "'#{l}'" }.join(', ')}"
              message
            end

            def ==(other)
              matches?(other)
            end

            def in_all_available_locales
              @tested_locales = I18n.available_locales
              self
            end

            def in_default_locale
              @tested_locales = [I18n.default_locale]
              self
            end

            # -------------------- private
            private

            def model_name_key
              "activerecord.models.#{@model.class.name.underscore}"
            end

          end

        end
      end
    end
  end
end
