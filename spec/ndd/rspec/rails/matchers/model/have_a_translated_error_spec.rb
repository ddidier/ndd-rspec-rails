require 'spec_helper'

# ----------------------------------------------------------------------------------------------------------------------

RSpec.shared_examples 'no attribute defined / error translated only in the default locale' do

  context 'and the translation in the default locale is tested' do
    it { is_expected.to have_a_translated_error(:no_default).in_default_locale }
  end

  context 'and the translation in all the available locales is tested' do
    it { is_expected.to_not have_a_translated_error(:no_default) }
    it { is_expected.to_not have_a_translated_error(:no_default).in_available_locales }

    it 'provides a failure message' do
      matcher = have_a_translated_error(:no_default).in_available_locales
      matcher.matches?(subject)
      message = "expected 'MyTranslatedModel' to have a translated error message for 'no_default'\n"
      message << "but none of the following keys was found:\n"
      message << "  - activerecord.errors.models.my_translated_model.no_default\n"
      message << "  - activerecord.errors.messages.no_default\n"
      message << "  - errors.messages.no_default\n"
      message << 'for the locales: :fr, :jp'
      expect(matcher.failure_message).to eq(message)
    end
  end

end

# ----------------------------------------------------------------------------------------------------------------------

RSpec.shared_examples 'attribute defined / error translated only in the default locale' do

  context 'and the translation in the default locale is tested' do
    it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
  end

  context 'and the translation in all the available locales is tested' do
    it { is_expected.to_not have_a_translated_error(:no_default).on_attribute(:content) }
    it { is_expected.to_not have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }

    it 'provides a failure message' do
      matcher = have_a_translated_error(:no_default).on_attribute(:content).in_available_locales
      matcher.matches?(subject)
      message = "expected 'MyTranslatedModel#content' to have a translated error message for 'no_default'\n"
      message << "but none of the following keys was found:\n"
      message << "  - activerecord.errors.models.my_translated_model.attributes.content.no_default\n"
      message << "  - activerecord.errors.models.my_translated_model.no_default\n"
      message << "  - activerecord.errors.messages.no_default\n"
      message << "  - errors.attributes.content.no_default\n"
      message << "  - errors.messages.no_default\n"
      message << 'for the locales: :fr, :jp'
      expect(matcher.failure_message).to eq(message)
    end
  end

end

# ----------------------------------------------------------------------------------------------------------------------

RSpec.describe 'have a translated error', type: :model do

  class MyTranslatedModel
  end

  # --------------------------------------------------------------------------------------------------------------------

  subject { MyTranslatedModel.new }

  before(:each) do
    I18n.default_locale = :en
    I18n.available_locales = %i[en fr jp]
    I18n.config.backend = I18n::Backend::KeyValue.new({})
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when there is no attribute defined' do

    # --------------------
    describe '#description' do

      context 'when the translation in the default locale is tested' do
        it 'provides a description' do
          expect(have_a_translated_error(:no_default).in_default_locale.description)
            .to eq("have a translated error message for 'no_default' in :en")
        end
      end

      context 'when the translations in all the available locales are tested' do
        it 'provides a description' do
          expect(have_a_translated_error(:no_default).description)
            .to eq("have a translated error message for 'no_default' in :en, :fr, :jp")
          expect(have_a_translated_error(:no_default).in_available_locales.description)
            .to eq("have a translated error message for 'no_default' in :en, :fr, :jp")
        end
      end
    end

    # --------------------
    context 'when the error is not translated' do

      context 'and the translation in the default locale is tested' do
        it { is_expected.to_not have_a_translated_error(:no_default).in_default_locale }

        it 'provides a failure message' do
          matcher = have_a_translated_error(:no_default).in_default_locale
          matcher.matches?(subject)
          message = "expected 'MyTranslatedModel' to have a translated error message for 'no_default'\n"
          message << "but none of the following keys was found:\n"
          message << "  - activerecord.errors.models.my_translated_model.no_default\n"
          message << "  - activerecord.errors.messages.no_default\n"
          message << "  - errors.messages.no_default\n"
          message << 'for the locales: :en'
          expect(matcher.failure_message).to eq(message)
        end
      end

      context 'and the translation in all the available locales is tested' do
        it { is_expected.to_not have_a_translated_error(:no_default) }
        it { is_expected.to_not have_a_translated_error(:no_default).in_available_locales }

        it 'provides a failure message' do
          matcher = have_a_translated_error(:no_default).in_available_locales
          matcher.matches?(subject)
          message = "expected 'MyTranslatedModel' to have a translated error message for 'no_default'\n"
          message << "but none of the following keys was found:\n"
          message << "  - activerecord.errors.models.my_translated_model.no_default\n"
          message << "  - activerecord.errors.messages.no_default\n"
          message << "  - errors.messages.no_default\n"
          message << 'for the locales: :en, :fr, :jp'
          expect(matcher.failure_message).to eq(message)
        end
      end
    end

    # --------------------
    context 'when the error is translated only in the default locale' do
      context 'when the translation key is errors.messages.{error_key}' do
        before(:each) do
          store_translation_1(:en, :no_default, 'my error')
        end
        include_examples 'no attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.errors.messages.{error_key}' do
        before(:each) do
          store_translation_2(:en, :no_default, 'my error')
        end
        include_examples 'no attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.errors.models.{model}.{error_key}' do
        before(:each) do
          store_translation_3(:en, :my_translated_model, :no_default, 'my error')
        end
        include_examples 'no attribute defined / error translated only in the default locale'
      end
    end

    # --------------------
    context 'when the error is translated in all the available locales' do
      context 'when the translation key is errors.messages.{error_key}' do
        before(:each) do
          store_translation_1(%i[en fr jp], :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default) }
        it { is_expected.to have_a_translated_error(:no_default).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).in_available_locales }
      end

      context 'when the translation key is activerecord.errors.messages.{error_key}' do
        before(:each) do
          store_translation_2(%i[en fr jp], :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default) }
        it { is_expected.to have_a_translated_error(:no_default).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).in_available_locales }
      end

      context 'when the translation key is activerecord.errors.models.{model}.{error_key}' do
        before(:each) do
          store_translation_3(%i[en fr jp], :my_translated_model, :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default) }
        it { is_expected.to have_a_translated_error(:no_default).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).in_available_locales }
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when there is a defined attribute' do

    # --------------------
    describe '#description' do

      context 'when the translation in the default locale is tested' do
        it 'provides a description' do
          expect(have_a_translated_error(:no_default).on_attribute(:content).in_default_locale.description)
            .to eq("have a translated error message for 'no_default' on 'content' in :en")
        end
      end

      context 'when the translations in all the available locales are tested' do
        it 'provides a description' do
          expect(have_a_translated_error(:no_default).on_attribute(:content).description)
            .to eq("have a translated error message for 'no_default' on 'content' in :en, :fr, :jp")
          expect(have_a_translated_error(:no_default).on_attribute(:content).in_available_locales.description)
            .to eq("have a translated error message for 'no_default' on 'content' in :en, :fr, :jp")
        end
      end
    end

    # --------------------
    context 'when the error is not translated' do

      context 'and the translation in the default locale is tested' do
        it { is_expected.to_not have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }

        it 'provides a failure message' do
          matcher = have_a_translated_error(:no_default).on_attribute(:content).in_default_locale
          matcher.matches?(subject)
          message = "expected 'MyTranslatedModel#content' to have a translated error message for 'no_default'\n"
          message << "but none of the following keys was found:\n"
          message << "  - activerecord.errors.models.my_translated_model.attributes.content.no_default\n"
          message << "  - activerecord.errors.models.my_translated_model.no_default\n"
          message << "  - activerecord.errors.messages.no_default\n"
          message << "  - errors.attributes.content.no_default\n"
          message << "  - errors.messages.no_default\n"
          message << 'for the locales: :en'
          expect(matcher.failure_message).to eq(message)
        end
      end

      context 'and the translation in all the available locales is tested' do
        it { is_expected.to_not have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to_not have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }

        it 'provides a failure message' do
          matcher = have_a_translated_error(:no_default).on_attribute(:content).in_available_locales
          matcher.matches?(subject)
          message = "expected 'MyTranslatedModel#content' to have a translated error message for 'no_default'\n"
          message << "but none of the following keys was found:\n"
          message << "  - activerecord.errors.models.my_translated_model.attributes.content.no_default\n"
          message << "  - activerecord.errors.models.my_translated_model.no_default\n"
          message << "  - activerecord.errors.messages.no_default\n"
          message << "  - errors.attributes.content.no_default\n"
          message << "  - errors.messages.no_default\n"
          message << 'for the locales: :en, :fr, :jp'
          expect(matcher.failure_message).to eq(message)
        end
      end
    end

    # --------------------
    context 'when the error is translated only in the default locale' do
      context 'when the translation key is errors.messages.{error_key}' do
        before(:each) do
          store_translation_1(:en, :no_default, 'my error')
        end
        include_examples 'attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.errors.messages.{error_key}' do
        before(:each) do
          store_translation_2(:en, :no_default, 'my error')
        end
        include_examples 'attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.errors.models.{model}.{error_key}' do
        before(:each) do
          store_translation_3(:en, :my_translated_model, :no_default, 'my error')
        end
        include_examples 'attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.attributes.{attribute}.{error_key}' do
        before(:each) do
          store_translation_4(:en, :content, :no_default, 'my error')
        end
        include_examples 'attribute defined / error translated only in the default locale'
      end

      context 'when the translation key is activerecord.errors.models.{model}.attributes.{attribute}.{error_key}' do
        before(:each) do
          store_translation_5(:en, :my_translated_model, :content, :no_default, 'my error')
        end
        include_examples 'attribute defined / error translated only in the default locale'
      end
    end

    # --------------------
    context 'when the error is translated in all the available locales' do
      context 'when the translation key is errors.messages.{error_key}' do
        before(:each) do
          store_translation_1(%i[en fr jp], :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }
      end

      context 'when the translation key is activerecord.errors.messages.{error_key}' do
        before(:each) do
          store_translation_2(%i[en fr jp], :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }
      end

      context 'when the translation key is activerecord.errors.models.{model}.{error_key}' do
        before(:each) do
          store_translation_3(%i[en fr jp], :my_translated_model, :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }
      end

      context 'when the translation key is activerecord.attributes.{attribute}.{error_key}' do
        before(:each) do
          store_translation_4(%i[en fr jp], :content, :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }
      end

      context 'when the translation key is activerecord.errors.models.{model}.attributes.{attribute}.{error_key}' do
        before(:each) do
          store_translation_5(%i[en fr jp], :my_translated_model, :content, :no_default, 'my error')
        end
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content) }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_default_locale }
        it { is_expected.to have_a_translated_error(:no_default).on_attribute(:content).in_available_locales }
      end
    end

  end

  # ----------------------------------------------------------------------------------------------- helper methods -----

  # errors.messages.{error_key} = {value},
  # i.e. errors.messages.no_default = 'some translation'
  def store_translation_1(locales, error_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      errors: { messages: { error_key => value } }
    end
  end

  # activerecord.errors.messages.{error_key} = {value},
  # i.e. activerecord.errors.messages.no_default = 'some translation'
  def store_translation_2(locales, error_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      activerecord: { errors: { messages: { error_key => value } } }
    end
  end

  # activerecord.errors.models.{model}.{error_key} = {value},
  # i.e. activerecord.errors.models.my_translated_model.no_default = 'some translation'
  def store_translation_3(locales, model_key, error_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      activerecord: { errors: { models: { model_key => { error_key => value } } } }
    end
  end

  # errors.attributes.{attribute}.{error_key} = {value},
  # i.e. errors.attributes.content.no_default = 'some translation'
  def store_translation_4(locales, attribute_key, error_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      errors: { attributes: { attribute_key => { error_key => value } } }
    end
  end

  # activerecord.errors.models.{model}.attributes.{attribute}.{error_key} = {value},
  # i.e. activerecord.errors.models.my_translated_model.attributes.content.no_default = 'some translation'
  def store_translation_5(locales, model_key, attribute_key, error_key, value)
    [*locales].each do |locale|
      I18n.backend.store_translations locale,
                                      activerecord: { errors: {
                                        models: { model_key => {
                                          attributes: { attribute_key => {
                                            error_key => value
                                          } }
                                        } }
                                      } }
    end
  end

end
