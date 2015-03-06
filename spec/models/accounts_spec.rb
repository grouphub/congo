require 'spec_helper'

describe Account do

  describe '#set_billing_start_and_day' do

    it 'saves the billing date' do
      today = Date.parse('January 20th, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create!
      billing_start = today + Account::DEMO_PERIOD

      expect(account.billing_start).to eq billing_start
      expect(account.billing_day).to eq billing_start.day
    end

    it 'bills on the 28th if the billing start is 29th-31st' do
      today = Date.parse('January 30th, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create!
      billing_start = today + Account::DEMO_PERIOD

      expect(account.billing_start).to eq billing_start
      expect(account.billing_day).to eq 28
    end

  end

  describe '#needs_to_pay?' do

    it 'returns false if user is user is in free tier' do
      a_long_time_ago = Date.parse('January 20th, 1980')

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'free',
        billing_start: a_long_time_ago,
        billing_day: a_long_time_ago.day

      expect(account.needs_to_pay?).to eq false
    end

    it 'returns false if user is user is in admin tier' do
      a_long_time_ago = Date.parse('January 20th, 1980')

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'admin',
        billing_start: a_long_time_ago,
        billing_day: a_long_time_ago.day

      expect(account.needs_to_pay?).to eq false
    end

    it 'returns false if is in demo period' do
      sign_up_date = Date.parse('January 20th, 1980')
      today = Date.parse('January 30th, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'basic',
        billing_start: sign_up_date,
        billing_day: sign_up_date.day

      expect(account.needs_to_pay?).to eq false
    end

    it 'returns true if user is out of demo period but has not yet paid' do
      sign_up_date = Date.parse('January 20th, 1980')
      today = Date.parse('February 20th, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'basic',
        billing_start: sign_up_date,
        billing_day: sign_up_date.day

      expect(account.needs_to_pay?).to eq true
    end

    it 'returns false if user has paid for the month' do
      sign_up_date = Date.parse('January 20th, 1980')
      today = Date.parse('February 22nd, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'basic',
        billing_start: sign_up_date,
        billing_day: sign_up_date.day

      Payment.create! \
        account_id: account.id

      expect(account.needs_to_pay?).to eq false
    end

    it 'returns true if user is out of demo period and has paid before' do
      sign_up_date = Date.parse('January 20th, 1980')
      today = Date.parse('March 30th, 1980')

      allow(Date).to receive(:today).and_return(today)

      account = Account.create! \
        name: 'Fun Account',
        plan_name: 'basic',
        billing_start: sign_up_date,
        billing_day: sign_up_date.day

      Payment.create! \
        account_id: account.id,
        created_at: sign_up_date

      expect(account.needs_to_pay?).to eq true
    end

  end

end

