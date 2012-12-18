require 'spec_helper'

describe "boms/new" do
  before(:each) do
    assign(:boms, stub_model(Bom).as_new_record)
  end

  it "renders new bom form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => boms_path, :method => "post" do
    end
  end
end
