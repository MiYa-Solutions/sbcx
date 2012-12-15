require 'spec_helper'

describe "boms/index" do
  before(:each) do
    assign(:boms, [
        stub_model(Bom),
        stub_model(Bom)
    ])
  end

  it "renders a list of boms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
