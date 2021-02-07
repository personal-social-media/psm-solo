require_relative "../spec_helper"

RSpec.describe FetchLatestCommit do
  subject do
    described_class.new.new_update?
  end

  it "ok" do
    subject
  end
end