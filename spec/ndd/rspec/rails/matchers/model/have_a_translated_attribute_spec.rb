require 'spec_helper'

RSpec.describe 'have a translated attribute', type: :model do

  class DoHaveATranslatedAttribute
  end

  class DoNotHaveATranslatedAttribute
  end

  # --------------------------------------------------------------------------------------------------------------------

  before(:each) do
    I18n.default_locale = :en
    I18n.config.backend = I18n::Backend::KeyValue.new({})
    I18n.backend.store_translations :en,
                                    activerecord: {
                                      attributes: {
                                        do_have_a_translated_attribute: {
                                          title: 'my title'
                                        }
                                      }
                                    }
  end

  # --------------------------------------------------------------------------------------------------------------------

  context 'when the model has a translation key for the attribute' do
    subject { DoHaveATranslatedAttribute.new }

    it { is_expected.to have_a_translated_attribute(:title) }

    it 'provides a description' do
      expect(have_a_translated_attribute(:title).description)
        .to eq("have a translated attribute name for 'title'")
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  context 'when the model has no translation key for the attribute' do
    subject { DoNotHaveATranslatedAttribute.new }

    it { is_expected.to_not have_a_translated_attribute(:content) }

    it 'provides a description' do
      expect(have_a_translated_attribute(:content).description)
        .to eq("have a translated attribute name for 'content'")
    end

    it 'provides a failure message' do
      matcher = have_a_translated_attribute(:content)
      matcher.matches?(subject)
      message = "expected 'DoNotHaveATranslatedAttribute' to have a translated attribute name for 'content\n"
      message << "but the 'activerecord.attributes.do_not_have_a_translated_attribute.content' key was not found"
      expect(matcher.failure_message).to eq(message)
    end
  end

end
