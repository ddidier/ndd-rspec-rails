require 'ndd/rspec/rails/matchers/translation_matcher'

module Ndd
  module RSpec
    module Rails
      module Matchers
        module Controller

          # Implements {#have_a_translated_flash}.
          class HaveATranslatedFlash < TranslationMatcher

            # @param message [String|Symbol] the message to test.
            def initialize(message)
              super()
              @message = message
            end

            # Set the action of the message to test.
            # @param action [String|Symbol] the action associated to the message to test.
            # @return self
            def on_action(action)
              @action = action
              self
            end

            # @param controller [Object] the controller being tested.
            # @return [Boolean] true if the message has an associated translation, false otherwise.
            def matches?(controller)
              @controller = controller
              @failed_locales = []
              @tested_locales.each do |tested_locale|
                @failed_locales << tested_locale unless translated_in?(tested_locale)
              end
              @failed_locales.empty?
            end

            # @return [String] a description of this matcher.
            def description
              description = "have a translated flash message for '#{@message}'"
              description << " on '#{@action}'" if @action.present?
              description << " in #{locales_as_string(@tested_locales)}"
              description
            end

            # @return [String] details about the failure of this matcher.
            def failure_message
              message = "expected '#{subject_as_string}' to have a translated flash message for '#{@message}'\n"
              message << "but none of the following keys was found:\n"
              message << "#{translation_keys.map { |l| "  - #{l}" }.join("\n")}\n"
              message << "for the locales: #{locales_as_string(@failed_locales)}"
              message
            end

            # -------------------- private
            private

            # @return [String] a human readable string of the subject of the error.
            def subject_as_string
              @action.present? ? "#{@controller.class}##{@action}" : @controller.class.to_s
            end

            def translation_keys
              @action.present? ? translation_keys_with_action : translation_keys_without_action
            end

            def translation_keys_with_action
              controller_key = @controller.class.name.underscore
              message_key = @message.to_s
              action_key = @action.to_s
              %W[
                actioncontroller.#{controller_key}.#{action_key}.flash.#{message_key}
                actioncontroller.#{controller_key}.flash.#{message_key}
                actioncontroller.#{action_key}.flash.#{message_key}
                actioncontroller.flash.#{message_key}
              ]
            end

            def translation_keys_without_action
              controller_key = @controller.class.name.underscore
              message_key = @message.to_s
              %W[
                actioncontroller.#{controller_key}.flash.#{message_key}
                actioncontroller.flash.#{message_key}
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
