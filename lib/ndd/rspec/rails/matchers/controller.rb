require 'rspec'
require_relative 'controller/have_a_translated_flash'

module Ndd
  module RSpec
    module Rails
      module Matchers
        # RSpec matchers for Rails controllers.
        module Controller

          # Ensure that a controller has a translated flash message for the given key.
          #
          # More precisely, ensure that (with all parameters being snake case) one of
          #   I18n.t(locale, "actioncontroller.#{controller_key}.#{action_key}.flash.#{message_key}")
          #   I18n.t(locale, "actioncontroller.#{controller_key}.flash.#{message_key}")
          #   I18n.t(locale, "actioncontroller.#{action_key}.flash.#{message_key}")
          #   I18n.t(locale, "actioncontroller.flash.#{message_key}")
          # returns a value for the default locale (i.e. +I18n.default_locale+)
          # or all the available locales (i.e. +I18n.available_locales+).
          #
          # @example
          #
          #   RSpec.describe MyController, type: :controller do
          #
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_flash(:out_of_range) }
          #     it { is_expected.to have_a_translated_flash(:out_of_range).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_flash(:out_of_range).in_default_locale }
          #
          #     # both are equivalent
          #     it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index) }
          #     it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }
          #
          #     it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
          #   end
          #
          # @param message [String|Symbol] the message to test.
          # @return [Ndd::RSpec::Rails::Matchers::Controller::HaveATranslatedFlash]
          #
          def have_a_translated_flash(message) # rubocop:disable Style/PredicateName
            HaveATranslatedFlash.new(message)
          end

        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Ndd::RSpec::Rails::Matchers::Controller, type: :controller
end
