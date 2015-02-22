require 'spec_helper'

describe Account do

  describe '#needs_to_pay?' do

  end

  describe '#enabled_features' do

    it 'returns a feature if it is enabled for all' do
      feature = Feature.create \
        name: 'foo',
        enabled_for_all: true

      account = Account.create

      expect(account.enabled_features).to eq([feature])
    end

    it 'returns a feature if it is enabled for the account' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[first_account]

      account = Account.create \
        name: 'First Account'

      expect(account.enabled_features).to eq([feature])
    end

    it 'does not return a feature if it is not available for an account' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[second_account]

      account = Account.create \
        name: 'First Account'

      expect(account.enabled_features).to eq([])
    end

  end

  describe '#feature_enabled?' do

    it 'returns true if the feature is enabled by account id' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[first_account]

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(true)
    end

    it 'returns true if the feature is enabled for all' do
      feature = Feature.create \
        name: 'foo',
        enabled_for_all: true

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(true)
    end

    it 'returns false if the feature is not enabled' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[second_account]

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(false)
    end

  end

end

