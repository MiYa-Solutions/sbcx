require 'spec_helper'

describe "boms/show" do
  before(:each) do
    @bom = assign(:bom, stub_model(Bom))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
