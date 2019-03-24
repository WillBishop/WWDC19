import Foundation
import SpriteKit

public class LevelThreeScene: SKScene{
    
    
    private var backButton: SKLabelNode?
    private var questionLabel: SKLabelNode?
    private var counterLabel: SKLabelNode?
    
    private var differenceNodes = [SKSpriteNode]()
    private var foundNodes = [SKSpriteNode](){
        didSet{
            //Update the counter and check for completion
            FontManager.convertToHalogen(label: counterLabel, text: "\(foundNodes.count)/5", fontSize: 50, withColor: ColorManager.neonGreen)
            if foundNodes.count >= 5{
                self.executeAfter(0.5, code: {
                    self.userDidFinishLevel(3)
                })
            }
        }
    }
    private var imageNode: SKSpriteNode?
    
    public override func didMove(to view: SKView) {
        
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        imageNode = self.childNode(withName: "imageNode") as? SKSpriteNode
        counterLabel = self.childNode(withName: "counterLabel") as? SKLabelNode
        differenceNodes = self.children.filter {$0.name == "differenceNode"}.compactMap {$0 as? SKSpriteNode}
        
        //We hide each difference node so the user can click it without being able to see it first.
        differenceNodes.forEach {node in
            node.color = .clear
        }
        
        FontManager.convertToHalogen(
            label: backButton,
            text: "< Back",
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        FontManager.convertToHalogen(
            label: counterLabel,
            text: "\(foundNodes.count)/5",
            fontSize: 50,
            withColor: ColorManager.neonGreen
        )
        FontManager.convertToHalogen(
            label: questionLabel,
            text: "Spot the difference!",
            fontSize: 50,
            withColor: ColorManager.neonBlue
        )
        
        //This gives the user enough time to get the bearings without actually witnessing the change.
        self.executeAfter(2.0, code: {
            FontManager.convertToHalogen(label: self.questionLabel, text: "3...", fontSize: 50, withColor: ColorManager.neonBlue)
        })
        self.executeAfter(3.0, code: {
            FontManager.convertToHalogen(label: self.questionLabel, text: "2...", fontSize: 50, withColor: ColorManager.neonBlue)
        })
        self.executeAfter(4.0, code: {
            FontManager.convertToHalogen(label: self.questionLabel, text: "1...", fontSize: 50, withColor: ColorManager.neonBlue)
        })
        self.executeAfter(5.0, code: {
            FontManager.convertToHalogen(label: self.questionLabel, text: "Close your eyes for three seconds!", fontSize: 50, withColor: ColorManager.neonBlue)
        })
        self.executeAfter(7.5, code: {
            guard let afterImage = Bundle.main.url(forResource: "after", withExtension: "png") else {return}
            guard let image = NSImage(contentsOf: afterImage) else {return}
            self.imageNode?.texture = SKTexture(image: image)
        })
        
        self.executeAfter(7.0, code: {
            FontManager.convertToHalogen(label: self.questionLabel, text: "Spot the 5 differences!", fontSize: 50, withColor: ColorManager.neonBlue)
        })
        
        
    }
    
    func executeAfter(_ seconds: Double, code: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            code()
        })
    }
    func addFoundCircle(to node: SKSpriteNode){
        let circleNode = SKShapeNode(circleOfRadius: 30)
        circleNode.position = node.position
        circleNode.fillColor = .clear
        circleNode.strokeColor = ColorManager.neonRed
        circleNode.lineWidth = 5
        self.addChild(circleNode)
    }
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let hitNodes = self.nodes(at: point)
        //If the user clicks the back button, quit
        if hitNodes.contains(where: {$0.name == "backButton"}){
            quit()
        }
        hitNodes.forEach {node in
            //If the node is in our difference node region, add a found circle to it and append that to our foundNodes
            if let hitDifference = self.differenceNodes.first(where: {$0 == (node as? SKSpriteNode)}){
                
                if !foundNodes.contains(hitDifference){
                    self.addFoundCircle(to: hitDifference)
                    foundNodes.append(hitDifference)
                }
            }
        }
        
    }
    public var userDidFinishLevel: (Int) -> Void = {level in}
    
    //Define a closure to quit, which is overwritten when the class is instantiated.
    public var quit: () -> Void = {}
}
