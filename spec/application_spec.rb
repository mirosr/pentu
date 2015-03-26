require_relative 'spec_helper'

describe Application do
  let(:described_entity) { Application }

  it 'saves the kittens' do
    output, = capture_io do
      described_entity.run
    end

    output.must_equal expected_application_output
  end

  private

  def expected_application_output
    <<EOS
=^.^= Quering forensics web service for directions... done!
=^.^= Sending a drone to follow the forensics directions... done!
=^.^= Drone's last location (x,y): 5,2
=^.^= Sending drone's last location to the forensics web service... done!
=^.^= Congratulations! The search party successfully recovered the missing kittens. Please zip up your code and send it to chris.patuzzo@which.co.uk
EOS
  end
end
