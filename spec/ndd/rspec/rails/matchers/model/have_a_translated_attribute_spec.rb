require 'spec_helper'

RSpec.describe 'have a translated attribute', type: :model do

  class DoHaveATranslatedAttribute
  end

  class DoNotHaveATranslatedAttribute
  end

  # --------------------------------------------------------------------------------------------------------------------

  before(:each) do
    I18n.default_locale = :en
    I18n.available_locales = %i[en fr jp]
    I18n.config.backend = I18n::Backend::KeyValue.new({})
    store_translation(:en, :do_have_a_translated_attribute, :title, 'my title')
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the attribute is not translated' do
    subject { DoNotHaveATranslatedAttribute.new }

    it 'provides a description' do
      expect(have_a_translated_attribute(:title).description)
        .to eq("have a translated attribute name for 'title'")
    end

    context 'and the translation in the default locale is tested' do
      it { is_expected.to_not have_a_translated_attribute(:title).in_default_locale }

      it 'provides a failure message' do
        matcher = have_a_translated_attribute(:title).in_default_locale
        matcher.matches?(subject)
        message = "expected 'DoNotHaveATranslatedAttribute' to have a translated attribute name for 'title\n"
        message << "but the 'activerecord.attributes.do_not_have_a_translated_attribute.title' key was not found\n"
        message << "for the locales: 'en'"
        expect(matcher.failure_message).to eq(message)
      end
    end

    context 'and the translation in all the available locales is tested' do
      it { is_expected.to_not have_a_translated_attribute(:title) }
      it { is_expected.to_not have_a_translated_attribute(:title).in_all_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_attribute(:title).in_all_available_locales
        matcher.matches?(subject)
        message = "expected 'DoNotHaveATranslatedAttribute' to have a translated attribute name for 'title\n"
        message << "but the 'activerecord.attributes.do_not_have_a_translated_attribute.title' key was not found\n"
        message << "for the locales: 'en', 'fr', 'jp'"
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the attribute is translated only in the default locale' do
    subject { DoHaveATranslatedAttribute.new }

    it 'provides a description' do
      expect(have_a_translated_attribute(:title).description)
        .to eq("have a translated attribute name for 'title'")
    end

    context 'and the translation in the default locale is tested' do
      it { is_expected.to have_a_translated_attribute(:title).in_default_locale }
    end

    context 'and the translation in all the available locales is tested' do
      it { is_expected.to_not have_a_translated_attribute(:title) }
      it { is_expected.to_not have_a_translated_attribute(:title).in_all_available_locales }

      it 'provides a failure message' do
        matcher = have_a_translated_attribute(:title).in_all_available_locales
        matcher.matches?(subject)
        message = "expected 'DoHaveATranslatedAttribute' to have a translated attribute name for 'title\n"
        message << "but the 'activerecord.attributes.do_have_a_translated_attribute.title' key was not found\n"
        message << "for the locales: 'fr', 'jp'"
        expect(matcher.failure_message).to eq(message)
      end
    end
  end

  # --------------------------------------------------------------------------------------------------------------------
  context 'when the attribute is translated in all the available locales' do
    before(:each) do
      store_translation(:fr, :do_have_a_translated_attribute, :title, 'mon modèle traduit')
      store_translation(:jp, :do_have_a_translated_attribute, :title, '私の翻訳したモデル')
      # if that doesn't mean anything, it's Google's fault ;-)
    end

    subject { DoHaveATranslatedAttribute.new }

    it 'provides a description' do
      expect(have_a_translated_attribute(:title).description).to eq("have a translated attribute name for 'title'")
    end

    it { is_expected.to have_a_translated_attribute(:title) }
    it { is_expected.to have_a_translated_attribute(:title).in_default_locale }
    it { is_expected.to have_a_translated_attribute(:title).in_all_available_locales }
  end

  # ----------------------------------------------------------------------------------------------- helper methods -----

  def store_translation(locale, class_key, attribute_key, value)
    I18n.backend.store_translations locale, activerecord: { attributes: { class_key => { attribute_key => value } } }
  end

end
