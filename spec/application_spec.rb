require 'spec_helper'

describe Application do
  let(:described_entity) { Application }

  it 'saves the kittens' do
    output, = capture_io do
      stub_directions_request do
        stub_result_request do
          described_entity.run
        end
      end
    end

    output.must_equal successful_rescue_output
  end

  context 'when the forensics service returns an error' do
    it 'does not saves the kittens' do
      output, = capture_io do
        stub_invalid_response do
          stub_result_request do
            described_entity.run
          end
        end
      end

      output.must_equal failed_rescue_output
    end
  end

  private

  def stub_directions_request(&block)
    body = '{"directions":["forward","right","forward","forward","forward","left","forward","forward","left","right","forward","right","forward","forward","right","forward","forward","left"]}'

    stub_adapter(:get_directions, body, &block)
  end

  def stub_result_request(&block)
    body = '{"message":"Congratulations! The search party successfully recovered the missing kittens."}'

    stub_adapter(:get_result, body, &block)
  end

  def stub_invalid_response(&block)
    stub_adapter(:get_directions, 'invalid json', &block)
  end

  def stub_adapter(method, body, is_http_ok = true, &block)
    response = MiniTest::Mock.new
    response.expect(:is_a?, is_http_ok, [Net::HTTPOK])
    response.expect(:body, body)

    ForensicsAdapter.stub(method, response, &block)
  end

  def successful_rescue_output
    <<EOS
=^.^= Quering forensics web service for directions... done!
=^.^= Sending a drone to follow the forensics directions... done!
=^.^= Drone's last location (x,y): 5,2
=^.^= Sending drone's last location to the forensics web service... done!
=^.^= Congratulations! The search party successfully recovered the missing kittens.
EOS
  end

  def failed_rescue_output
    <<EOS
=^.^= Quering forensics web service for directions... done!
=^.^= No drones were sent since the forensics web service returned an error:

757: unexpected token at 'invalid json'

=^.^= No kittens were saved!!! :(
EOS
  end
end
