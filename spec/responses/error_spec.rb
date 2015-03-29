require 'spec_helper'

describe Responses::Error do
  let(:described_entity) { Responses::Error }

  it 'contains an error message' do
    response = described_entity.load(json_response)

    response.error.must_equal error_message
  end

  it 'contains an empty value' do
    response = described_entity.load(json_response)

    response.value.must_be :empty?
    response.error?.must_equal true
  end

  describe '.general' do
    it 'retuns a response the error message' do
      response = described_entity.general(error_message)

      response.value.must_be :empty?
      response.error.must_equal error_message
    end
  end

  private

  def json_response
    %q({"error":"Invalid email address: 'miro'"})
  end

  def error_message
    %q(Invalid email address: 'miro')
  end
end
