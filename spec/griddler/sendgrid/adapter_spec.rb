require 'spec_helper'

describe Griddler::Sendgrid::Adapter, '.normalize_params' do
  it_should_behave_like 'Griddler adapter',
    :sendgrid,
    {
      text: 'hi',
      to: 'Hello World <hi@example.com>',
      cc: 'emily@example.com',
      from: 'There <there@example.com>',
    }

  it 'changes attachments to an array of files' do
    params = default_params.merge(
      attachments: '2',
      attachment1: upload_1,
      attachment2: upload_2,
     'attachment-info' => <<-eojson
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
      eojson
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

  def default_params
    {
      text: 'hi',
      to: 'hi@example.com',
      cc: 'cc@example.com',
      from: 'there@example.com',
    }
  end
end
