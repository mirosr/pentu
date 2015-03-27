require_relative 'spec_helper'
require 'net/http'

describe ForensicsAdapter do
  let(:described_entity) { ForensicsAdapter }

  describe '.directions' do
    it 'returns the received directions as hash' do
      Net::HTTP.stub(:get_response, json_mock) do
        described_entity.directions.must_equal directions_hash
      end
    end
  end

  private

  def json_mock
    response = MiniTest::Mock.new

    response.expect(:body, '{"directions":["forward","right","forward","left"]}')

    response
  end

  def directions_hash
    {
      "directions" => [
        "forward",
        "right",
        "forward",
        "left"
      ]
    }
  end
end
