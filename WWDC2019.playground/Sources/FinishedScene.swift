import Foundation
import SpriteKit

public class FinishedScene: SKScene{
    
    //Construct our two main labels
    public var welcomeLabel: SKLabelNode?
    public var instructionLabel: SKLabelNode?
    
    //Create an array of labels for future iterating
    private var labels = [SKLabelNode]()
    
    //These are used to define default sizes and colours, allowing for easy changes in the future
    var welcomeSize: CGFloat = 50.0
    var welcomeColor = ColorManager.neonBlue
    
    var instructionSize: CGFloat = 20.0
    var instructionColor = ColorManager.neonGreen
    
    var defaultSize: CGFloat = 20.0
    var defaultColor = ColorManager.neonGreen
    
    public override func didMove(to view: SKView) {
        welcomeLabel = self.childNode(withName: "welcome") as? SKLabelNode
        instructionLabel = self.childNode(withName: "instruction") as? SKLabelNode
        self.labels = self.children.compactMap {$0 as? SKLabelNode }
        
        //Convert each label on the page to use the halogen font included with the bundle.
        self.labels.forEach { label in
            var size: CGFloat = 0.0
            var name = label.name ?? ""
            if name.contains("welcome"){
                size = welcomeSize
            } else if name.contains("instruction"){
                size = instructionSize
            } else {
                size = defaultSize
            }
            var color = NSColor()
            if name.contains("welcome"){
                color = welcomeColor
            } else if name.contains("instruction"){
                color = instructionColor
            } else {
                color = defaultColor
            }
            FontManager.convertToHalogen(
                label: label,
                text: label.text!,
                fontSize: size,
                withColor: color
            )
        }
       
    }
}
