require 'spec_helper'
require_relative '../../lib/abstract'

describe "abstract methods" do
  before(:each) do
    @klass = Class.new do
      include Abstract

      abstract_methods :foo, :bar
    end
  end

  it "raises NotImplementedError" do
    expect {
      @klass.new.foo
    }.to raise_error(NotImplementedError)
  end

  it "can be overridden" do
    subclass = Class.new(@klass) do
      def foo
        :overridden
      end
    end

    subclass.new.foo.should == :overridden
  end
end