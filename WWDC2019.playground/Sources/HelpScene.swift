import Foundation
import SpriteKit

public class HelpScene: SKScene{
    
    //Construct our titleLabel node and title String. `title` has a `didSet` listener for easy setup
    private var titleLabel: SKLabelNode?
    public var title: String?{
        didSet{
            titleLabel?.removeFromParent()
            titleLabel = SKLabelNode(text: title)
            titleLabel?.position.x = self.frame.midX
            titleLabel?.position.y = self.frame.midY + 50
            titleLabel?.name = "title"
            self.addChild(titleLabel!)
        }
    }
    
    //Same principal as above.
    private var subtitleLabel: SKLabelNode?
    public var subtitle: String?{
        didSet{
            subtitleLabel?.removeFromParent()
            subtitleLabel = SKLabelNode(text: subtitle)
            subtitleLabel?.position.x = self.frame.midX
            subtitleLabel?.position.y = self.frame.midY - 50
            subtitleLabel?.name = "subtitle"
            self.addChild(subtitleLabel!)
        }
    }
    //All our labels are stored in a convinient array for future use.
    private var labels = [SKLabelNode]()
    
    //The default size for titles, subtitles, and all other labels is configured along with their colours.
    var titleSize: CGFloat = 65.0
    var titleColor = ColorManager.neonBlue
    
    var subtitleSize: CGFloat = 40.0
    var subtitleColor = ColorManager.neonGreen
    
    var defaultSize: CGFloat = 20.0
    var defaultColor = ColorManager.neonGreen
    
    public override func didMove(to view: SKView) {
        
        //Attempt to cast every node in our view to a SKLabelNode and discard the results which fail
        self.labels = self.children.compactMap {$0 as? SKLabelNode }
        
        //Convert each label on the page to use the halogen font included with the bundle.
        self.labels.forEach { label in
            var size: CGFloat = 0.0
            var name = label.name ?? ""
            print(name)
            if name == "title"{
                size = titleSize
            } else if name == "subtitle"{
                print("Assigning subbitlte size")
                size = subtitleSize
            } else if name.contains("back"){
                size = 65.0
            } else {
                size = defaultSize
            }
            var color = NSColor()
            if name.contains("title"){
                color = titleColor
            } else if name.contains("subtitle"){
                color = subtitleColor
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
    public var quit: () -> Void = {}
    
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)

        let hitNodes = self.nodes(at: point)
        print(point)
        //If the user clicks the back button, quit
        if hitNodes.contains(where: {$0.name == "backButton"}){
            quit()
        }
    }
}
