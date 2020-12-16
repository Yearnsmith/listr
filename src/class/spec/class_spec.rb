require_relative '../list'

# List class

describe List do

  list = List.new("My test")
  
  it "should have a title" do
    expect(list.list_title).to eq("My test")
  end
  
  it "should be an instance of List" do
    expect(list).to be_instance_of List
  end

  it "should be able to add items"
  
  end

end

describe State do
  
  state = State.new

  it "should have a name that defaults to \"default\"" do
    expect(state.state_name).to eq ("default")
  end

  it "should list all ruby files in 'files' dir" do
    expect(state.files).to eq ()
  end

end