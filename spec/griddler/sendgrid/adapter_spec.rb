# frozen-string-literal: true

require 'spec_helper'

describe Griddler::Sendgrid::Adapter do
  it 'registers itself with griddler' do
    Griddler.adapter_registry[:sendgrid].should eq Griddler::Sendgrid::Adapter
  end
end

describe Griddler::Sendgrid::Adapter, '.normalize_params' do
  it_should_behave_like 'Griddler adapter',
    :sendgrid,
    {
      text: 'hi',
      to: 'Hello World <hi@example.com>',
      cc: 'emily@example.com',
      from: 'There <there@example.com>',
      charsets: { to: 'UTF-8', text: 'iso-8859-1' }.to_json
    }

  it 'changes attachments to an array of files' do
    params = default_params.merge(
      attachments: '2',
      attachment1: upload_1,
      attachment2: upload_2,
      'attachment-info' => <<-EOJSON
        {
          'attachment2': {
            'filename': 'photo2.jpg',
            'name': 'photo2.jpg',
            'type': 'image/jpeg'
          },
          'attachment1': {
            'filename': 'photo1.jpg',
            'name': 'photo1.jpg',
            'type': 'image/jpeg'
          }
        }
      EOJSON
    )

    normalized_params = normalize_params(params)
    normalized_params[:attachments].should eq [upload_1, upload_2]
    normalized_params.should_not have_key(:attachment1)
    normalized_params.should_not have_key(:attachment2)
    normalized_params.should_not have_key(:attachment_info)
  end

  it 'has no attachments' do
    params = default_params.merge(attachments: '0')

    normalized_params = normalize_params(params)
    normalized_params[:attachments].should be_empty
  end

  it 'wraps to in an array' do
    normalized_params = normalize_params(default_params)

    normalized_params[:to].should eq [default_params[:to]]
  end

  it 'wraps cc in an array' do
    normalized_params = normalize_params(default_params)

    normalized_params[:cc].should eq [default_params[:cc]]
  end

  it 'returns an array even if cc is empty' do
    params = default_params.merge(cc: nil)
    normalized_params = normalize_params(params)

    normalized_params[:cc].should eq []
  end

  it 'returns the charsets as a hash' do
    normalized_params = normalize_params(default_params)
    charsets = normalized_params[:charsets]

    charsets.should be_present
    charsets[:text].should eq 'iso-8859-1'
    charsets[:to].should eq 'UTF-8'
  end

  it 'does not explode if charsets is not JSON-able' do
    params = default_params.merge(charsets: 'This is not JSON')

    normalize_params(params)[:charsets].should eq({})
  end

  it 'defaults charsets to an empty hash if it is not specified in params' do
    params = default_params.except(:charsets)
    normalize_params(params)[:charsets].should eq({})
  end

  def default_params
    {
      text: 'hi',
      to: 'hi@example.com',
      cc: 'cc@example.com',
      from: 'there@example.com',
      charsets: { to: 'UTF-8', text: 'iso-8859-1' }.to_json
    }
  end
end
