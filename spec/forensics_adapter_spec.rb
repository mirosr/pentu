require 'spec_helper'

describe ForensicsAdapter do
  let(:described_entity) { ForensicsAdapter }

  describe '.directions' do
    it 'returns a response with the received directions' do
      stub_directions_request do
        response = described_entity.directions
        
        response.must_be_kind_of Responses::Directions
        response.value.wont_be :empty?
        response.error.must_be :empty?
      end
    end

    context 'when the remote service returns a response with error' do
      it 'retuns a response the error message' do
        stub_error_request do
          response = described_entity.directions

          response.must_be_kind_of Responses::Error
          response.value.must_be :empty?
          response.error.wont_be :empty?
        end
      end
    end

    context 'when the response cannot be parsed' do
      it 'retuns a response with the error message' do
        stub_invalid_response do
          response = described_entity.directions

          response.must_be_kind_of Responses::Error
          response.value.must_be :empty?
          response.error.must_match /unexpected token at 'invalid_json'/
        end
      end
    end
  end

  describe '.submit_location' do
    it 'returns a response with the received result' do
      stub_result_request do
        response = described_entity.submit_location(x: 0, y: 0)

        response.must_be_kind_of Responses::Result
        response.value.wont_be :empty?
        response.error.must_be :empty?
      end
    end

    context 'when the response cannot be parsed' do
      it 'retuns a response with the error message' do
        stub_invalid_response do
          response = described_entity.submit_location(x: 0, y: 0)

          response.must_be_kind_of Responses::Error
          response.value.must_be :empty?
          response.error.must_match /unexpected token at 'invalid_json'/
        end
      end
    end
  end

  private

  def stub_directions_request(&block)
    response = MiniTest::Mock.new

    response.expect(:is_a?, true, [Net::HTTPOK])
    response.expect(:body, '{"directions":["forward"]}')

    stub_http_request(response, &block)
  end

  def stub_result_request(&block)
    response = MiniTest::Mock.new

    response.expect(:is_a?, true, [Net::HTTPOK])
    response.expect(:body, '{"message":"Congratulations!"}')


    stub_http_request(response, &block)
  end

  def stub_error_request(&block)
    response = MiniTest::Mock.new

    response.expect(:is_a?, false, [Net::HTTPOK])
    response.expect(:body, %({"error":"Invalid email address"}))

    stub_http_request(response, &block)
  end

  def stub_invalid_response(&block)
    response = MiniTest::Mock.new

    response.expect(:is_a?, true, [Net::HTTPOK])
    response.expect(:body, 'invalid_json')

    stub_http_request(response, &block)
  end

  def stub_http_request(response, &block)
    Net::HTTP.stub(:get_response, response, &block)
  end
end
