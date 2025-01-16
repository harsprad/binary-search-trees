require_relative "lib/tree"

bst = Tree.new(Array.new(15) { rand(1..100) })
puts "New BSTree created"
bst.p_print
puts "Is tree balanced?: #{bst.balanced?}"
puts ""
puts "Elements of tree in level, pre, post, and in order (resp):"
p bst.level_order
p bst.depth_order(:pre)
p bst.depth_order(:post)
p bst.depth_order(:in)
puts ""
puts "..adding elements to tree.."
10.times{ bst.insert(rand(100..1000)) }
puts ""
puts "Is tree balanced? #{bst.balanced?}"
puts ""
puts "...balancing tree..."
puts ""
bst.rebalance
puts "Is tree balanced? #{bst.balanced?}"
puts ""
puts "Elements of tree in level, pre, post, and in order (resp):"
p bst.level_order
p bst.depth_order(:pre)
p bst.depth_order(:post)
p bst.depth_order(:in)
bst.p_print
