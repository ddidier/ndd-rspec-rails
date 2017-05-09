require 'active_support/core_ext/string/inflections'
require 'i18n'

module Ndd
  module RSpec
    module Rails
      module Matchers
        module Model

          def have_a_translated_model
            HaveATranslatedModel.new
          end

          # ------------------------------------------------------------------------------------------------------------
          # Ensures that a model has a translated name.
          #
          # Examples:
          #
          #   RSpec.describe MyModel, type: :model do
          #     it { is_expected.to have_a_translated_model }
          #   end
          #
          class HaveATranslatedModel

            def matches?(model)
              @model = model
              begin
                I18n.t(model_name_key, raise: true)
                return true
              rescue I18n::MissingTranslationData
                return false
              end
            end

            def description
              'have a translated model name'
            end

            def failure_message
              message = ''
              message << "expected '#{@model.class}' to have a translated model name\n"
              message << "but the '#{model_name_key}' key was not found"
              message
            end

            def ==(other)
              matches?(other)
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
