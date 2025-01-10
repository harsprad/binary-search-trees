require_relative 'node'

class Tree
  def initialize(arr)
    @root = build_tree(arr)
    @n = arr.uniq.length
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
    node_v = Node.new(value)

    @n.times do
      return value if node_v == node
      if node_v < node
        if node.left.nil?
          @n += 1
          node.left = node_v
          return value
        else
          node = node.left
        end
      else
        if node.right.nil?
          @n += 1
          node.right = node_v
          return value
        else
          node = node.right
        end
      end
    end
  end
end
