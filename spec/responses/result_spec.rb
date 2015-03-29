require 'spec_helper'

describe Responses::Result do
  let(:described_entity) { Responses::Result }

  it 'contains a string with the received result' do
    response = described_entity.load(json_response)

    response.value.must_equal result_string
  end

  it 'does not contain an error message' do
    response = described_entity.load(json_response)

    response.error.must_equal ''
  end

  private

  def json_response
    '{"message":"Congratulations!"}'
  end

  def result_string
    'Congratulations!'
  end
end
