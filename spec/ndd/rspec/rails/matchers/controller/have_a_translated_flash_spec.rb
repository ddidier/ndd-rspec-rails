require 'spec_helper'

# ----------------------------------------------------------------------------------------------------------------------

RSpec.shared_examples 'no action defined / message translated only in the default locale' do

  context 'and the translation in the default locale is tested' do
    it { is_expected.to have_a_translated_flash(:out_of_range).in_default_locale }
  end

  context 'and the translation in all the available locales is tested' do
    it { is_expected.to_not have_a_translated_flash(:out_of_range) }
    it { is_expected.to_not have_a_translated_flash(:out_of_range).in_available_locales }

    it 'provides a failure message' do
      matcher = have_a_translated_flash(:out_of_range).in_available_locales
      matcher.matches?(subject)
      message = "expected 'MyTranslatedController' to have a translated flash message for 'out_of_range'\n"
      message << "but none of the following keys was found:\n"
      message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
      message << "  - actioncontroller.flash.out_of_range\n"
      message << 'for the locales: :fr, :jp'
      expect(matcher.failure_message).to eq(message)
    end
  end

end

# ----------------------------------------------------------------------------------------------------------------------

RSpec.shared_examples 'action defined / message translated only in the default locale' do

  context 'and the translation in the default locale is tested' do
    it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
  end

  context 'and the translation in all the available locales is tested' do
    it { is_expected.to_not have_a_translated_flash(:out_of_range).on_action(:index) }
    it { is_expected.to_not have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }

    it 'provides a failure message' do
      matcher = have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales
      matcher.matches?(subject)
      message = "expected 'MyTranslatedController#index' to have a translated flash message for 'out_of_range'\n"
      message << "but none of the following keys was found:\n"
      message << "  - actioncontroller.my_translated_controller.index.flash.out_of_range\n"
      message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
      message << "  - actioncontroller.index.flash.out_of_range\n"
      message << "  - actioncontroller.flash.out_of_range\n"
      message << 'for the locales: :fr, :jp'
      expect(matcher.failure_message).to eq(message)
    end
  end

end

# ----------------------------------------------------------------------------------------------------------------------

RSpec.describe 'have a translated flash message', type: :controller do

  class MyTranslatedController
  end

  # --------------------------------------------------------------------------------------------------------------------

  subject { MyTranslatedController.new }

  before(:each) do
    I18n.default_locale = :en
    I18n.available_locales = %i[en fr jp]
    I18n.config.backend = I18n::Backend::KeyValue.new({})
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when there is no action defined' do

    # --------------------
    describe '#description' do

      context 'when the translation in the default locale is tested' do
        it 'provides a description' do
          expect(have_a_translated_flash(:out_of_range).in_default_locale.description)
            .to eq("have a translated flash message for 'out_of_range' in :en")
        end
      end

      context 'when the translations in all the available locales are tested' do
        it 'provides a description' do
          expect(have_a_translated_flash(:out_of_range).description)
            .to eq("have a translated flash message for 'out_of_range' in :en, :fr, :jp")
          expect(have_a_translated_flash(:out_of_range).in_available_locales.description)
            .to eq("have a translated flash message for 'out_of_range' in :en, :fr, :jp")
        end
      end
    end

    # --------------------
    context 'when the message is not translated' do

      context 'and the translation in the default locale is tested' do
        it { is_expected.to_not have_a_translated_flash(:out_of_range).in_default_locale }

        it 'provides a failure message' do
          matcher = have_a_translated_flash(:out_of_range).in_default_locale
          matcher.matches?(subject)
          message = "expected 'MyTranslatedController' to have a translated flash message for 'out_of_range'\n"
          message << "but none of the following keys was found:\n"
          message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
          message << "  - actioncontroller.flash.out_of_range\n"
          message << 'for the locales: :en'
          expect(matcher.failure_message).to eq(message)
        end
      end

      context 'and the translation in all the available locales is tested' do
        it { is_expected.to_not have_a_translated_flash(:out_of_range) }
        it { is_expected.to_not have_a_translated_flash(:out_of_range).in_available_locales }

        it 'provides a failure message' do
          matcher = have_a_translated_flash(:out_of_range).in_available_locales
          matcher.matches?(subject)
          message = "expected 'MyTranslatedController' to have a translated flash message for 'out_of_range'\n"
          message << "but none of the following keys was found:\n"
          message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
          message << "  - actioncontroller.flash.out_of_range\n"
          message << 'for the locales: :en, :fr, :jp'
          expect(matcher.failure_message).to eq(message)
        end
      end
    end

    # --------------------
    context 'when the message is translated only in the default locale' do

      context 'when the translation key is actioncontroller.{controller_key}.flash.{message_key}' do
        before(:each) do
          store_translation_1(:en, :my_translated_controller, :out_of_range, 'my message')
        end
        include_examples 'no action defined / message translated only in the default locale'
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_2(:en, :out_of_range, 'my message')
        end
        include_examples 'no action defined / message translated only in the default locale'
      end

    end

    # --------------------
    context 'when the message is translated in all the available locales' do

      context 'when the translation key is actioncontroller.{controller_key}.flash.{message_key}' do
        before(:each) do
          store_translation_1(%i[en fr jp], :my_translated_controller, :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range) }
        it { is_expected.to have_a_translated_flash(:out_of_range).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).in_available_locales }
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_2(%i[en fr jp], :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range) }
        it { is_expected.to have_a_translated_flash(:out_of_range).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).in_available_locales }
      end

    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when there is a defined action' do

    # --------------------
    describe '#description' do

      context 'when the translation in the default locale is tested' do
        it 'provides a description' do
          expect(have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale.description)
            .to eq("have a translated flash message for 'out_of_range' on 'index' in :en")
        end
      end

      context 'when the translations in all the available locales are tested' do
        it 'provides a description' do
          expect(have_a_translated_flash(:out_of_range).on_action(:index).description)
            .to eq("have a translated flash message for 'out_of_range' on 'index' in :en, :fr, :jp")
          expect(have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales.description)
            .to eq("have a translated flash message for 'out_of_range' on 'index' in :en, :fr, :jp")
        end
      end
    end

    # --------------------
    context 'when the message is not translated' do

      context 'and the translation in the default locale is tested' do
        it { is_expected.to_not have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }

        it 'provides a failure message' do
          matcher = have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale
          matcher.matches?(subject)
          message = "expected 'MyTranslatedController#index' to have a translated flash message for 'out_of_range'\n"
          message << "but none of the following keys was found:\n"
          message << "  - actioncontroller.my_translated_controller.index.flash.out_of_range\n"
          message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
          message << "  - actioncontroller.index.flash.out_of_range\n"
          message << "  - actioncontroller.flash.out_of_range\n"
          message << 'for the locales: :en'
          expect(matcher.failure_message).to eq(message)
        end
      end

      context 'and the translation in all the available locales is tested' do
        it { is_expected.to_not have_a_translated_flash(:out_of_range).on_action(:index) }
        it { is_expected.to_not have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }

        it 'provides a failure message' do
          matcher = have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales
          matcher.matches?(subject)
          message = "expected 'MyTranslatedController#index' to have a translated flash message for 'out_of_range'\n"
          message << "but none of the following keys was found:\n"
          message << "  - actioncontroller.my_translated_controller.index.flash.out_of_range\n"
          message << "  - actioncontroller.my_translated_controller.flash.out_of_range\n"
          message << "  - actioncontroller.index.flash.out_of_range\n"
          message << "  - actioncontroller.flash.out_of_range\n"
          message << 'for the locales: :en, :fr, :jp'
          expect(matcher.failure_message).to eq(message)
        end
      end
    end

    # --------------------
    context 'when the message is translated only in the default locale' do

      context 'when the translation key is actioncontroller.{controller_key}.flash.{message_key}' do
        before(:each) do
          store_translation_1(:en, :my_translated_controller, :out_of_range, 'my message')
        end
        include_examples 'action defined / message translated only in the default locale'
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_2(:en, :out_of_range, 'my message')
        end
        include_examples 'action defined / message translated only in the default locale'
      end

      context 'when the translation key is actioncontroller.{action_key}.flash.{message_key}' do
        before(:each) do
          store_translation_3(:en, :index, :out_of_range, 'my message')
        end
        include_examples 'action defined / message translated only in the default locale'
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_4(:en, :out_of_range, 'my message')
        end
        include_examples 'action defined / message translated only in the default locale'
      end

    end

    # --------------------
    context 'when the message is translated in all the available locales' do

      context 'when the translation key is actioncontroller.{controller_key}.flash.{message_key}' do
        before(:each) do
          store_translation_1(%i[en fr jp], :my_translated_controller, :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index) }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_2(%i[en fr jp], :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index) }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }
      end

      context 'when the translation key is actioncontroller.{action_key}.flash.{message_key}' do
        before(:each) do
          store_translation_3(%i[en fr jp], :index, :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index) }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }
      end

      context 'when the translation key is actioncontroller.flash.{message_key}' do
        before(:each) do
          store_translation_4(%i[en fr jp], :out_of_range, 'my message')
        end
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index) }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_default_locale }
        it { is_expected.to have_a_translated_flash(:out_of_range).on_action(:index).in_available_locales }
      end

    end

  end

  # ----------------------------------------------------------------------------------------------- helper methods -----

  # actioncontroller.{controller_key}.flash.{message_key} = {value},
  # i.e. actioncontroller.my_translated_controller.flash.out_of_range = 'some translation'
  def store_translation_1(locales, controller_key, message_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      actioncontroller: { controller_key => { flash: { message_key => value } } }
    end
  end

  # actioncontroller.flash.{message_key} = {value},
  # i.e. actioncontroller.flash.out_of_range = 'some translation'
  def store_translation_2(locales, message_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      actioncontroller: { flash: { message_key => value } }
    end
  end

  # actioncontroller.{action_key}.flash.{message_key} = {value},
  # i.e. actioncontroller.index.flash.no_default = 'some translation'
  def store_translation_3(locales, action_key, message_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      actioncontroller: { action_key => { flash: { message_key => value } } }
    end
  end

  # actioncontroller.flash.{message_key} = {value},
  # i.e. actioncontroller.flash.no_default = 'some translation'
  def store_translation_4(locales, message_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      actioncontroller: { flash: { message_key => value } }
    end
  end

end
