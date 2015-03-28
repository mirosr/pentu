require 'spec_helper'

describe ForensicsAdapter do
  let(:described_entity) { ForensicsAdapter }

  describe '.directions' do
    it 'returns a response with the received directions' do
      Net::HTTP.stub(:get_response, json_mock) do
        response = described_entity.directions
        
        response.must_be_kind_of Responses::Directions
        response.value.wont_be :empty?
        response.error.must_be :empty?
      end
    end

    context 'when the remote service returns a response with error' do
      it 'retuns a response the error message' do
        Net::HTTP.stub(:get_response, error_mock) do
          response = described_entity.directions

          response.must_be_kind_of Responses::Error
          response.value.must_be :empty?
          response.error.wont_be :empty?
        end
      end
    end

    context 'when the respone cannot be parsed' do
      it 'retuns a response the error message' do
        Net::HTTP.stub(:get_response, invalid_mock) do
          response = described_entity.directions

          response.must_be_kind_of Responses::Error
          response.value.must_be :empty?
          response.error.must_match /unexpected token at 'invalid_json'/
        end
      end
    end
  end

  private

  def json_mock
    response = MiniTest::Mock.new

    response.expect(:is_a?, true, [Net::HTTPOK])
    response.expect(:body, '{"directions":["forward"]}')

    response
  end

  def error_mock
    response = MiniTest::Mock.new

    response.expect(:is_a?, false, [Net::HTTPOK])
    response.expect(:body, %({"error":"Invalid email address"}))

    response
  end

  def invalid_mock
    response = MiniTest::Mock.new

    response.expect(:is_a?, true, [Net::HTTPOK])
    response.expect(:body, 'invalid_json')

    response
  end
end
