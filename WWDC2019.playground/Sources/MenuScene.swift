import Foundation
import SpriteKit

public class MenuScene: SKScene{
    
    
    //Declare the onscreen labels in the menu
    public var startLabel: SKLabelNode!
    private var endLabel: SKLabelNode!
    
    //Declare the array of levels nodes for hit detection
    private var levels = [LevelNode]()
    public var levelPaths = [CGMutablePath]()
    
    //This should not change
    private let numberOfLevels = 5
    
    private var levelNodeWidth: CGFloat = 30.0
    
    private var connecterLineWidth: CGFloat = 2.0
    
    public var zoomed = false
    
    public static var animationTime: TimeInterval = 0.75
    public override func sceneDidLoad() {
        //Get the label node from the scene and assign them to the variables declared on line 9 and 10.
        startLabel = self.childNode(withName: "startLabel") as? SKLabelNode
        endLabel = self.childNode(withName: "endLabel") as? SKLabelNode
        
        
        FontManager.convertToHalogen(label: startLabel, text: "Start", fontSize: 50, withColor: ColorManager.neonBlue)
        FontManager.convertToHalogen(label: endLabel, text: "WWDC", fontSize: 50, withColor: ColorManager.neonGreen)
        //Setup our camera
        let cameraNode = SKCameraNode()
        //Center it in our view
        cameraNode.position = CGPoint(x: 0, y: 0)
        
        //Add our camera to the view, and assign it to the scenes camera variable
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        for levelCount in 1 ... numberOfLevels{
            print("Creating Level \(levelCount)")
            
            //Create a LevelNode (SKShapeNode)
            let level = LevelNode(circleOfRadius: 30)
            //Assign the level to it
            level.level = levelCount
            
            //Create an x and a y position for our level
            var xPosition = Int()
            var yPosition = Int()
            
            //The position of each level is determined by switch-ing over their value
            switch level.level{
            case 1:
                xPosition = -120
                yPosition = -275
            case 2:
                xPosition = 200
                yPosition = -200
            case 3:
                xPosition = -100
                yPosition = 0
            case 4:
                xPosition = -250
                yPosition = 250
            case 5:
                xPosition = 100
                yPosition = 250
            default:
                fatalError("Error: Too many levels. Expected 5 but got \(self.numberOfLevels)")
            }
            
            
            
            //Give the nodes a little flare
            level.position = CGPoint(x: xPosition, y: yPosition)
            level.fillColor = self.backgroundColor
            level.strokeColor = .clear
            level.zPosition = 1
            
            
            //Create a level number label
            let levelLabel = SKLabelNode(fontNamed: FontManager.neonFont.fontName)
            levelLabel.fontSize = 50
            levelLabel.text = "\(level.level ?? 0)"
            levelLabel.position = level.position
            levelLabel.fontColor = NSColor(red:0.69, green:0.44, blue:0.97, alpha:1.0)
            levelLabel.verticalAlignmentMode = .center
            
            level.associatedLabel = levelLabel
            //This ensures the level label is in front of both our level node and connecter line
            
            levelLabel.zPosition = 999
            
            //Create a various storing the previous LevelNode's position, or create a point in the middle right of the start label if a level does not yet exist
            let previousPoint = self.levels.last?.position ?? CGPoint(x: self.startLabel.frame.maxX, y: self.startLabel.frame.midY)
            let currentPoint = level.position
            //Create a mutable path to link our level nodes
            let levelConnecterLine = CGMutablePath()
            //Move the starting point to our previous node point
            levelConnecterLine.move(to: previousPoint)
            //Add the new node point
            levelConnecterLine.addLine(to: currentPoint)
            //Create a new shape which connects each level
            let shape = SKShapeNode()
            shape.path = levelConnecterLine
            shape.strokeColor = .white
            shape.lineWidth = connecterLineWidth
            shape.zPosition = 0.01
            self.addChild(shape)
            
            //Construct a '?' button for users to get help
            let helpLabel = SKLabelNode(text: "?")
            FontManager.convertToHalogen(label: helpLabel, text: "?", fontSize: 50.0, withColor: ColorManager.neonWhite)
            helpLabel.position = CGPoint(x: self.frame.maxX - helpLabel.frame.width, y: self.frame.minY + (helpLabel.frame.height / 2))
            
            //Append the level to our `level` array.
            self.levels.append(level)
            
            //Append our paths to the `levelPaths` array
            self.levelPaths.append(levelConnecterLine)
            
            //Add the level to our scene
            self.addChild(level)
            
            //Add our level label
            self.addChild(levelLabel)
            
            //Add our help node
            self.addChild(helpLabel)
            
            
            
            
        }
        
        //Create the last line from our last level to WWDC
        guard let lastPoint = self.levels.last?.position else {return}
        
        let WWDCPoint = CGPoint(x: self.endLabel.frame.minX, y: self.endLabel.frame.midY)
        
        let finalLine = CGMutablePath()
        finalLine.move(to: lastPoint)
        finalLine.addLine(to: WWDCPoint)
        self.levelPaths.append(finalLine)
        
        let shape = SKShapeNode()
        shape.path = finalLine
        shape.strokeColor = .white
        shape.lineWidth = 2
        self.addChild(shape)
    }
    public override func didMove(to view: SKView) {
        
    }
    
    @objc static public override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    public func animateInto(level: Int, finished: @escaping () -> Void){
        let levelNode = levels[level - 1]
        let moveAction = SKAction.move(to: levelNode.position, duration: MenuScene.animationTime)
        let zoomAction = SKAction.scale(by: 0.04, duration: MenuScene.animationTime)
        // let alphaAction = SKAction.fadeAlpha(to: 0, duration: animationTime)
        //level.associatedLabel?.run(alphaAction)
        self.camera?.run(moveAction)
        self.camera?.run(zoomAction, completion: {
            finished()
        })
    }
    public func animateOutOf(level: LevelNode){
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: MenuScene.animationTime)
        let zoomAction = SKAction.scale(to: 1.0, duration: MenuScene.animationTime)
        //let alphaAction = SKAction.fadeAlpha(to: 1, duration: animationTime)
        // level.associatedLabel?.run(alphaAction)
        self.camera?.run(moveAction)
        self.camera?.run(zoomAction)
    }
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let hitNodes = self.nodes(at: point)
        
        let levelNodes = hitNodes.compactMap {$0 as? LevelNode}
        if let level = levelNodes.first{
            guard let _ = level.level else {
                fatalError("Could not find level")
            }
            
            if !zoomed{
                zoomed = true
                loadLevel(level.level!)
            } else {
                print("Zoom out")
                zoomed = false
                self.animateOutOf(level: level)
            }
            
        } else if hitNodes.contains((startLabel as SKNode)){
             loadLevel(1)
        } else {
            print("Else")
            guard let hitNode = hitNodes.first else {return}
            print("Got nodes")
            if let helpNode = hitNode as? SKLabelNode{
                if helpNode.attributedText?.string == "?"{
                    print("Getting help")
                    self.getHelpForLevel(0)
                    
                } else {
                    print("Got this instead")
                    print(helpNode.attributedText?.string)
                }
            } else{
                print("Wouldn't let as label")
            }
        }
        
        
    }
    public var loadLevel: (Int) -> Void = {_ in}
    public var getHelpForLevel: (Int) -> Void = {_ in}
    
    
    
}
