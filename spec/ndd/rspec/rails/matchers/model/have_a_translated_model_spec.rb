require 'spec_helper'

RSpec.describe 'have a translated model', type: :model do

  class DoHaveATranslatedModel
  end

  class DoNotHaveATranslatedModel
  end

  # --------------------------------------------------------------------------------------------------------------------

  before(:each) do
    I18n.default_locale = :en
    I18n.config.backend = I18n::Backend::KeyValue.new({})
    I18n.backend.store_translations :en,
                                    activerecord: {
                                      models: {
                                        do_have_a_translated_model: 'my translated model'
                                      }
                                    }
  end

  # --------------------------------------------------------------------------------------------------------------------

  context 'when the model has a translation key' do
    subject { DoHaveATranslatedModel.new }

    it { is_expected.to have_a_translated_model }

    it 'provides a description' do
      expect(have_a_translated_model.description).to eq('have a translated model name')
    end
  end

  # --------------------------------------------------------------------------------------------------------------------

  context 'when the model has no translation key' do
    subject { DoNotHaveATranslatedModel.new }

    it { is_expected.to_not have_a_translated_model }

    it 'provides a description' do
      expect(have_a_translated_model.description).to eq('have a translated model name')
    end

    it 'provides a failure message' do
      matcher = have_a_translated_model
      matcher.matches?(subject)
      message = "expected 'DoNotHaveATranslatedModel' to have a translated model name\n"
      message << "but the 'activerecord.models.do_not_have_a_translated_model' key was not found"
      expect(matcher.failure_message).to eq(message)
    end
  end

end
