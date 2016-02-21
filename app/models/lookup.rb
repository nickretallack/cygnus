class Lookup < ActiveRecord::Base

  def Lookup.make(parent, child = nil)
    lookup = Lookup.new(parent: parent)
    lookup.children = [child] if child
    lookup.save!
  end

  def Lookup.parents_of(child)
    parents = []
    Lookup.find("children = ANY (?)", child).each do |lookup|
      parents << lookup.parent
    end
    parents
  end

  def Lookup.children_of(parent)
    children = []
    Lookup.find(parent: parent).each do |lookup|
      children << lookup.parent
    end
    children
  end

end
