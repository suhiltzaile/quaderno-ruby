require 'helper'

describe Quaderno::Tax do
  context 'A user with an authenticate token with webhooks' do

    before(:each) do
      Quaderno::Base.configure do |config|
        config.auth_token = TEST_KEY
        config.url = TEST_URL
        config.api_version = nil
      end
    end

    it 'should raise exception if token is wrong' do
      VCR.use_cassette('wrong token') do
        Quaderno::Base.auth_token = '7h15154f4k370k3n'
        expect { Quaderno::Tax.calculate(country: 'ES', postal_code: '08080') }.to raise_error(Quaderno::Exceptions::InvalidSubdomainOrToken)
      end
    end

    it 'should validate VAT numbe' do
      VCR.use_cassette('validate valid VAT number') do
        vat_number_valid = Quaderno::Tax.validate_vat_number('IE', 'IE6388047V')
        expect(vat_number_valid).to be true
      end

       VCR.use_cassette('validate invalid VAT number') do
        vat_number_valid = Quaderno::Tax.validate_vat_number('IE', 'IE6388047X')
        expect(!vat_number_valid).to be true
      end
    end
  end
end