require 'spec_helper'

describe "boms/edit" do
  before(:each) do
    @bom = assign(:boms, stub_model(Bom))
  end

  it "renders the edit bom form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boms_path(@bom), :method => "post" do
    end
  end
end
