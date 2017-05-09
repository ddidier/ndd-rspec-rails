module Ndd
  module RSpec
    module Rails
      module Matchers
        module Model

          def have_a_translated_attribute(attribute)
            HaveATranslatedAttribute.new(attribute)
          end

          # ------------------------------------------------------------------------------------------------------------
          # Ensures that an attribute of a model has a translated name.
          #
          # Examples:
          #
          #   RSpec.describe MyModel, type: :model do
          #     it { is_expected.to have_a_translated_attribute(:comment) }
          #   end
          #
          class HaveATranslatedAttribute

            def initialize(attribute)
              @attribute = attribute
            end

            def matches?(model)
              @model = model
              begin
                I18n.t(attribute_name_key, raise: true)
                return true
              rescue I18n::MissingTranslationData
                return false
              end
            end

            def description
              "have a translated attribute name for '#{@attribute}'"
            end

            def failure_message
              message = ''
              message << "expected '#{@model.class}' to have a translated attribute name for '#{@attribute}\n"
              message << "but the '#{attribute_name_key}' key was not found"
              message
            end

            def ==(other)
              matches?(other)
            end

            # -------------------- private
            private

            def attribute_name_key
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
