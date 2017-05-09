require 'spec_helper'

RSpec.describe 'have a translated model', type: :model do

  class DoHaveATranslatedModel
  end

  class DoNotHaveATranslatedModel
  end

  # --------------------------------------------------------------------------------------------------------------------

  before(:each) do
    I18n.default_locale = :en
    I18n.available_locales = %i[en fr jp]
    I18n.config.backend = I18n::Backend::KeyValue.new({})
    store_translation(:en, :do_have_a_translated_model, 'my translated model')
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is not translated' do
    subject { DoNotHaveATranslatedModel.new }

    it 'provides a description' do
      expect(have_a_translated_model.description).to eq('have a translated model name')
    end

    context 'and the translation in the default locale is tested' do
      it { is_expected.to_not have_a_translated_model.in_default_locale }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_default_locale
        matcher.matches?(subject)
        message = "expected 'DoNotHaveATranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.do_not_have_a_translated_model' key was not found\n"
        message << "for the locales: 'en'"
        expect(matcher.failure_message).to eq(message)
      end
    end

    context 'and the translation in all the available locales is tested' do
      it { is_expected.to_not have_a_translated_model }
      it { is_expected.to_not have_a_translated_model.in_all_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_all_available_locales
        matcher.matches?(subject)
        message = "expected 'DoNotHaveATranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.do_not_have_a_translated_model' key was not found\n"
        message << "for the locales: 'en', 'fr', 'jp'"
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is translated only in the default locale' do
    subject { DoHaveATranslatedModel.new }

    it 'provides a description' do
      expect(have_a_translated_model.description).to eq('have a translated model name')
    end

    context 'and the translation in the default locale is tested' do
      it { is_expected.to have_a_translated_model.in_default_locale }
    end

    context 'and the translation in all the available locales is tested' do
      it { is_expected.to_not have_a_translated_model }
      it { is_expected.to_not have_a_translated_model.in_all_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_model.in_all_available_locales
        matcher.matches?(subject)
        message = "expected 'DoHaveATranslatedModel' to have a translated model name\n"
        message << "but the 'activerecord.models.do_have_a_translated_model' key was not found\n"
        message << "for the locales: 'fr', 'jp'"
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the model is translated in all the available locales' do
    before(:each) do
      store_translation(:fr, :do_have_a_translated_model, 'mon modèle traduit')
      store_translation(:jp, :do_have_a_translated_model, '私の翻訳したモデル')
      # if that doesn't mean anything, it's Google's fault ;-)
    end

    subject { DoHaveATranslatedModel.new }

    it 'provides a description' do
      expect(have_a_translated_model.description).to eq('have a translated model name')
    end

    it { is_expected.to have_a_translated_model }
    it { is_expected.to have_a_translated_model.in_default_locale }
    it { is_expected.to have_a_translated_model.in_all_available_locales }
  end

  # ----------------------------------------------------------------------------------------------- helper methods -----

  def store_translation(locale, class_key, value)
    I18n.backend.store_translations locale, activerecord: { models: { class_key => value } }
  end

end
