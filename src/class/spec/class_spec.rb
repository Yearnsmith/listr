require_relative '../list'
require_relative '../state'
# List class

describe List do
  $state = State.load_state
  list = List.new("My test")
  
  it "should have a title" do
    expect(list.list_title).to eq("My test")
  end
  
  it "should be an instance of List" do
    expect(list).to be_instance_of List
  end

  # it "should be able to add items"
  
  # end

  it "should only store up to 5 items in @removed_items array" do
    list.list_items <<  "1" << "2" << "3" << "4" << "5" << "6" << "7"
    list.removed_items = [[0,"a"],[2,"b"],[6,"c"],[7,"d"],[3,"e"]]
    
    list.remove_item("6")
    # expect(list.removed_items.length).should be(<= 5)
    expect(1..5).to cover(list.removed_items.length)
  end

end

describe State do
  
  state = State.new

  it "should have a name that defaults to \"default\"" do
    expect(state.state_name).to eq ("default")
  end

  # it "should list all ruby files in 'files' dir" do
  #   expect(state.files).to eq ()
  # end

end