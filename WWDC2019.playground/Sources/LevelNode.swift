import Foundation
import SpriteKit


/// LevelNode adds a couple values to a regular SKShapeNode for convinience
public class LevelNode: SKShapeNode{
    
    //Each level node can track its level number
    public var level: Int?
    
    //The associated label is the number on top of the node.
    public var associatedLabel: SKLabelNode?
    
}
