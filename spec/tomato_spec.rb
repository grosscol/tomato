require "spec_helper"

RSpec.describe Tomato do
  it "has a version number" do
    expect(Tomato::VERSION).not_to be nil
  end
end
