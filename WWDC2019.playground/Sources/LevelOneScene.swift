import Foundation
import SpriteKit
import AppKit

public class LevelOneScene: SKScene{
    
    private var backButton: SKLabelNode?
    
    private var questionLabel: SKLabelNode?
    
    //This is the nodes where users enter their numbers
    private var enterNodes: [SKShapeNode] = []
    
    private var potentialAnswers: [SKLabelNode] = []
    
    var previousPoint = CGPoint(x: 0, y: 0)
    
    var firstNumber = Int.random(in: 2 ... 9)
    var secondNumber = Int.random(in: 2 ... 9)
    
    var finished = false
    var processing = false
    var questionCount = 2
    var completedQuestions = 0
    
    private var correctFirstNumber = false
    private var correctSecondNumber = false
    /*
     Neighbour
     Their/There
     Crocodile
     February
     Library
     Used
     Denial
     Every
     
     */
    var correctAnswer: String{
        return String(describing: firstNumber * secondNumber)
    }
    var isDraggingNode = false
    var draggingNode: SKLabelNode?
    
    public override func didMove(to view: SKView) {
        
        //Assign our label variables a value, corresponding with their on-screen components.
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        
        
        
        //Convert each label on the page to use the halogen font included with the bundle.
        FontManager.convertToHalogen(
            label: backButton,
            text: "< Back",
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        enterNodes = [
            SKShapeNode(rectOf: CGSize(width: 100, height: 175)),
            SKShapeNode(rectOf: CGSize(width: 100, height: 175)),
        ]
        
        enterNodes[0].name = "enterNode1"
        enterNodes[1].name = "enterNode2"
        
        enterNodes[0].position.x = self.frame.midX - enterNodes[0].frame.width + 10
        enterNodes[1].position.x = self.frame.midX + enterNodes[1].frame.width - 10
        
        enterNodes.forEach{ node in
            self.addChild(node)
        }
        
        self.setupNumbers()
        
    }
    
    func numberIntersectsWithImportantObjects(_ answerLabel: SKLabelNode) -> Bool{
        return self.potentialAnswers.contains(where: {$0.frame.intersects(answerLabel.frame)}) ||
            self.enterNodes.contains(where: {$0.frame.intersects(answerLabel.frame)}) ||
            (self.questionLabel?.frame.contains(answerLabel.frame) ?? false)
    }
    
    func setupNumbers(){
        potentialAnswers.forEach {num in
            num.removeFromParent()
        }
        potentialAnswers.removeAll()
        print("Assigning numbers")
        firstNumber = Int.random(in: 2 ... 9)
        secondNumber = Int.random(in: 2 ... 9)
        print("Constructing label")
        FontManager.convertToHalogen(label: questionLabel, text: "What is \(firstNumber) times \(secondNumber)?", fontSize: 60, withColor: ColorManager.neonBlue)

        for answer in 0 ... 9{
            let answerLabel = SKLabelNode()
            FontManager.convertToHalogen(label: answerLabel, text: String(describing: answer), fontSize: 80.0, withColor: ColorManager.neonWhite)
            
            let max = 50
            let min = -400
            let positionY = CGFloat(Int.random(in: min ... max))
            answerLabel.position.y = positionY
            answerLabel.position.x = CGFloat(Int.random(in: -490 ... 460))
            
            while numberIntersectsWithImportantObjects(answerLabel){
                let positionY = CGFloat(Int.random(in: min ... max))
                print(positionY)
                answerLabel.position.y = positionY
                answerLabel.position.x = CGFloat(Int.random(in: -500 ... 500))
            }
            potentialAnswers.append(answerLabel)
        }
        for (index, element) in potentialAnswers.enumerated(){
            if index != 0{
            }
            self.addChild(element)
        }
        
    }
    
    public override func mouseUp(with event: NSEvent) {
        draggingNode = nil
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let point = event.location(in: self)
        if let hitNode = draggingNode ?? self.nodes(at: point).first as? SKLabelNode {
            
            draggingNode = hitNode
            if !( ((hitNode.name?.contains("enter")) ?? false) || ((hitNode.name?.contains("back")) ?? false) || ((hitNode.name?.contains("question")) ?? false)){
                let newPoint = CGPoint(x: point.x, y: point.y - (hitNode.frame.height / 2))
                var snapped = false
                for (index, enterNode) in enterNodes.enumerated(){
                    if enterNode.frame.contains(hitNode.frame){
                        snapped = true
                        
                        //First enter box
                        if index == 0{
                            print("\(hitNode.attributedText?.string) into \(correctAnswer.first!)")
                            if hitNode.attributedText?.string == String(correctAnswer.first!){
                                hitNode.position = CGPoint(x: enterNode.frame.midX, y: enterNode.frame.midY - (hitNode.frame.height / 2 ))
                                FontManager.convertToHalogen(label: hitNode, text: String(correctAnswer.first!), fontSize: 80, withColor: ColorManager.neonGreen)
                                correctFirstNumber = true
                                if correctAnswer.count == 1{
                                    correctSecondNumber = true
                                }
                            } else {
                                FontManager.convertToHalogen(label: hitNode, text: hitNode.attributedText!.string, fontSize: 80, withColor: ColorManager.neonRed)
                                hitNode.position = newPoint
                                
                            }
                        }
                        if index == 1{
                            print("\(hitNode.attributedText?.string) into \(correctAnswer.last!)")
                            if hitNode.attributedText?.string == String(correctAnswer.last!){
                                hitNode.position = CGPoint(x: enterNode.frame.midX, y: enterNode.frame.midY - (hitNode.frame.height / 2 ))
                                FontManager.convertToHalogen(label: hitNode, text: String(correctAnswer.last!), fontSize: 80, withColor: ColorManager.neonGreen)
                                correctSecondNumber = true
                                if correctAnswer.count == 1{
                                    correctFirstNumber = true
                                }
                            } else {
                                FontManager.convertToHalogen(label: hitNode, text: hitNode.attributedText!.string, fontSize: 80, withColor: ColorManager.neonRed)
                                
                                hitNode.position = newPoint
                                
                            }
                        }
                    } else {
                        if !snapped{
                            FontManager.convertToHalogen(label: hitNode, text: hitNode.attributedText!.string, fontSize: 80, withColor: ColorManager.neonWhite)
                            hitNode.position = newPoint
                        }
                    }
                    if correctFirstNumber && correctSecondNumber && !finished{
                        print("Finsihed")
                        print(completedQuestions)
                        print(questionCount)
                        if completedQuestions <= questionCount && !processing{
                            processing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                                self.finished = false
                                self.completedQuestions += 1
                                print("Incremented number")
                                self.setupNumbers()
                                print("Setup numbers")
                                self.correctFirstNumber = false
                                self.correctSecondNumber = false
                                self.processing = false
                                
                            })
                        } else {
                            if completedQuestions >= questionCount{
                               self.userDidFinishLevel(1)
                            }
                        }
                    }
                }
            }
        }
        previousPoint = point
        
    }
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let hitNodes = self.nodes(at: point)
        print(point)
        //If the user clicks the back button, quit
        if hitNodes.contains(where: {$0.name == "backButton"}){
            quit()
        }
        
    }
    public var userDidFinishLevel: (Int) -> Void = {level in}
    
    //Define a closure to quit, which is overwritten when the class is instantiated.
    public var quit: () -> Void = {}
    
}
