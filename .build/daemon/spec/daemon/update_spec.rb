require_relative "../spec_helper"

RSpec.describe Update do
  subject do
    described_class.new.run
  end

  it "ok" do
    subject
  end
end