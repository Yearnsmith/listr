# List Class

# Lists:
# [X] Are objects of List class.
# [ ] Have a title
# [ ] Contain items
# [ ] Store items in an array
# [ ] Store title and items together in a hash/YAML format
# [ ] Are saved to disc in YAML format

Class List

attr_accessor :list_title, :list_items, :list_hash

def initialize(list_hash)
  @list_title = list_hash.to_a[0][0]
  @list_contents = list_hash[@list_title]
  @list_hash = list_hash
end




end
