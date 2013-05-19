require 'spec_helper'

describe Space do
  before :each do
    @alice = Factory(:space, name: 'Alice', domain: 'example.org', path: 'alice')
    @bob = Factory(:space, name: 'Bob', domain: 'examble.org', path: 'bob')
  end

  it 'sends a message'
  it 'receives a message'
  it 'rejects an anonymous message'
end
