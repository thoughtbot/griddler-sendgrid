require 'spec_helper'

describe Griddler::Email, '#to_h' do
  it 'accepts normalized params from Griddler::Sendgrid::Adapter' do
    normalized_params = Griddler::Sendgrid::Adapter.normalize_params(default_params)
    email = Griddler::Email.new(normalized_params)

    email_properties = email.to_h

    expect(email_properties[:subject]).to eq 'Some subject'
    expect(email_properties[:spam_score]).to eq '1.234'
  end

  def default_params
    {
      subject: 'Some subject',
      text: 'hi',
      to: '"Mr Fugushima at Fugu, Inc" <hi@example.com>, Foo bar <foo@example.com>, Eichhörnchen <squirrel@example.com>, <no-name@example.com>',
      cc: 'cc@example.com',
      from: 'there@example.com',
      envelope: "{\"to\":[\"johny@example.com\"], \"from\": [\"there@example.com\"]}",
      spam_score: '1.234',
      spam_report: 'Some spam report',
    }
  end
end
