require_relative 'node'

class Tree
  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr)
    data = arr.uniq.sort

    balance(data, 0, data.length - 1)
  end

  def balance(data, start_ind, end_ind)
    return nil if start_ind > end_ind

    mid_ind = start_ind + ((end_ind-start_ind)/2).to_i
    node = Node.new(data[mid_ind])

    node.left = balance(data, start_ind, mid_ind - 1)
    node.right = balance(data, mid_ind + 1, end_ind)

    node
  end

  # p_print code from a student from The Odin Project
  def p_print(node = @root, prefix = '', is_left = true)
    p_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    p_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    node = @root
    new_node = Node.new(value)

    loop do
      return if value == node.data
      side = value < node.data ? :left : :right
      if node.send(side).nil?
        node.send("#{side}=", new_node)
        break
      end
      node = node.send(side)
    end 
  end

  def delete(value)
    node = @root

    until node.nil? do
      return delete_node(node) if node.data == value
      node = node.data > value ? node.left : node.right
    end
  end

  def delete_node(node)
    node.data = pop_closest_sub_node(node)
  end

  def pop_closest_sub_node(node)
    return nil unless node.children?

    supra_node = node
    if !node.right.nil?
      leftest_right = node.right
      until leftest_right.left.nil?
        supra_node = leftest_right
        leftest_right = leftest_right.left
      end
      supra_node.right = leftest_right.right if supra_node == node
      supra_node.left = leftest_right.right unless supra_node == node 
      return leftest_right.data
    else
      rightest_left = node.left
      until rightest_left.right.nil?
        supra_node = rightest_left
        rightest_left = rightest_left.right
      end
      supra_node.left = rightest_left.left if supra_node == node
      supra_node.right = rightest_left.left unless supra_node == node 
      return rightest_left.data
    end
  end
end
