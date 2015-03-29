require 'spec_helper'

describe Application do
  let(:described_entity) { Application }

  it 'saves the kittens' do
    output, = capture_io do
      stub_adapter(:get_directions, directions_response) do
        stub_adapter(:get_result, result_response) do
          described_entity.run
        end
      end
    end

    output.must_equal successful_rescue_output
  end

  context 'when the forensics service returns an error' do
    it 'does not saves the kittens' do
      output, = capture_io do
        stub_adapter(:get_directions, invalid_response) do
          stub_adapter(:get_result, result_response) do
            described_entity.run
          end
        end
      end

      output.must_equal failed_rescue_output
    end
  end

  private

  def stub_adapter(method, response, &block)
    ForensicsAdapter.stub(method, response, &block)
  end

  def directions_response
    json = '{"directions":["forward","right","forward","forward","forward","left","forward","forward","left","right","forward","right","forward","forward","right","forward","forward","left"]}'

    Net::HTTPOK.new('1.1', 200, json)
  end

  def result_response
    json = '{"message":"Congratulations! The search party successfully recovered the missing kittens."}'

    Net::HTTPOK.new('1.1', 200, json)
  end

  def invalid_response
    json = 'invalid_json'

    Net::HTTPOK.new('1.1', 200, json)
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

757: unexpected token at 'invalid_json'

=^.^= No kittens were saved!!! :(
EOS
  end
end
