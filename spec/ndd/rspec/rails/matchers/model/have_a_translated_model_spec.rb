require 'spec_helper'

RSpec.describe 'have a translated model', type: :model do

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
  describe '#description' do

    context 'when the translation in the default locale is tested' do
      it 'provides a description' do
        expect(have_a_translated_model.in_default_locale.description)
          .to eq('have a translated model name in :en')
      end
    end

    context 'when the translations in all the available locales are tested' do
      it 'provides a description' do
        expect(have_a_translated_model.description)
          .to eq('have a translated model name in :en, :fr, :jp')
        expect(have_a_translated_model.in_available_locales.description)
          .to eq('have a translated model name in :en, :fr, :jp')
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is not translated' do

    context 'and the translation in the default locale is tested' do
      it { is_expected.to_not have_a_translated_model.in_default_locale }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_default_locale
        matcher.matches?(subject)
        message = "expected 'MyTranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.my_translated_model' key was not found\n"
        message << 'for the locales: :en'
        expect(matcher.failure_message).to eq(message)
      end
    end

    context 'and the translations in all the available locales are tested' do
      it { is_expected.to_not have_a_translated_model }
      it { is_expected.to_not have_a_translated_model.in_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_available_locales
        matcher.matches?(subject)
        message = "expected 'MyTranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.my_translated_model' key was not found\n"
        message << 'for the locales: :en, :fr, :jp'
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is translated only in the default locale' do

    before(:each) do
      store_translation(:en, :my_translated_model, 'my translated model')
    end

    context 'and the translation in the default locale is tested' do
      it { is_expected.to have_a_translated_model.in_default_locale }
    end

    context 'and the translations in all the available locales are tested' do
      it { is_expected.to_not have_a_translated_model }
      it { is_expected.to_not have_a_translated_model.in_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_available_locales
        matcher.matches?(subject)
        message = "expected 'MyTranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.my_translated_model' key was not found\n"
        message << 'for the locales: :fr, :jp'
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is translated in all the available locales' do

    before(:each) do
      store_translation(:en, :my_translated_model, 'my translated model')
      store_translation(:fr, :my_translated_model, 'mon modèle traduit')
      store_translation(:jp, :my_translated_model, '私の翻訳したモデル')
      # if that doesn't mean anything, it's Google's fault ;-)
    end

    it { is_expected.to have_a_translated_model }
    it { is_expected.to have_a_translated_model.in_default_locale }
    it { is_expected.to have_a_translated_model.in_available_locales }
  end

  # ----------------------------------------------------------------------------------------------- helper methods -----

  def store_translation(locale, model_key, value)
    I18n.backend.store_translations locale, activerecord: { models: { model_key => value } }
  end

end
