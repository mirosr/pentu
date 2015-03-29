require 'spec_helper'

describe Responses::Directions do
  let(:described_entity) { Responses::Directions }

  it 'contains an array with the received directions' do
    response = described_entity.load(json_response)

    response.value.must_equal directions_array
  end

  it 'does not contain an error message' do
    response = described_entity.load(json_response)

    response.error.must_equal ''
    response.error?.must_equal false
  end

  private

  def json_response
    '{"directions":["forward","right","forward","left"]}'
  end

  def directions_array
    [
      "forward",
      "right",
      "forward",
      "left"
    ]
  end
end
