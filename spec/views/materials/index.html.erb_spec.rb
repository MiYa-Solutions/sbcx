require 'spec_helper'

describe "materials/index" do
  before(:each) do
    assign(:materials, [
        stub_model(Material),
        stub_model(Material)
    ])
  end

  it "renders a list of materials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
