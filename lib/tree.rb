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

  def find(value, node=@root)
    until node.data == value || node.nil?
      node = value < node.data ? node.left : node.right
    end 

    node
  end

  def level_order
    pointer = 0
    queue = []
    queue << @root unless @root.nil?
    while pointer < queue.length
      node = queue[pointer]
      queue.append(node.left) unless node.left.nil?
      queue.append(node.right) unless node.right.nil?
      pointer += 1
    end

    if block_given?
      return queue.map{ |node| yield(node) }
    else
      return queue.map{ |node| node.data }
    end
  end

  def level_order_recursive(queue=[@root], &block)
    return [] if queue.length == 0

    node = queue.shift
    queue.append(node.left) unless node.left.nil?
    queue.append(node.right) unless node.right.nil?

    if block_given?
      [ block.call(node) ].concat(level_order_recursive(queue, &block))
    else
      [ node.data ].concat(level_order_recursive(queue))
    end
  end

  def depth_order(type, node=@root, &block)
    return [] if node.nil?
    valid_types = [:pre, :in, :post]
    raise ArgumentError, "Invalid" unless valid_types.include?(type)

    result = []
    if type == :pre
      result << (block_given? ? block.call(node) : node.data)
    end
    result.concat(depth_order(type, node.left, &block)) 
    if type == :in
    result << (block_given? ? block.call(node) : node.data)
    end
    result.concat(depth_order(type, node.right, &block))
    if type == :post
    result << (block_given? ? block.call(node) : node.data) 
    end
    result
  end
end
