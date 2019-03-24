import Foundation
import SpriteKit
import AppKit

public class LevelOneScene: SKScene{
    
    private var backButton: SKLabelNode?
    
    private var questionLabel: SKLabelNode?
    
    //This is the nodes where users enter their numbers
    private var enterNodes: [SKShapeNode] = []
    private var counterLabel: SKLabelNode?

    private var potentialAnswers: [SKLabelNode] = []
    
    //Generate two random numbers, from 2 to 9.
    //0 is omitted as 0 times anything is 0 and 1 is omitted as I like to avoid numbers where when x * y, the result is less than 10.
    var firstNumber = Int.random(in: 2 ... 9)
    var secondNumber = Int.random(in: 2 ... 9)
    
    var finished = false
    
    //Processing indicators if we're in the middle of updating the scene.
    var processing = false
    
    //The number of questions n - 1
    var questionCount = 2
    
    //When this is set we update our counter label.
    var completedQuestions = 0{
        didSet{
            FontManager.convertToHalogen(label: counterLabel, text: "\(completedQuestions)/\(questionCount + 1)", fontSize: 50, withColor: ColorManager.neonGreen)
        }
    }
    
    //Indicates if the user has got it right
    private var correctFirstNumber = false
    private var correctSecondNumber = false

    //Our correct answer is treated as a string and is a read-only variable.
    var correctAnswer: String{
        return String(describing: firstNumber * secondNumber)
    }
    
    //We keep track of our currently dragged node
    var draggingNode: SKLabelNode?
    
    public override func didMove(to view: SKView) {
        
        //Assign our label variables a value, corresponding with their on-screen components.
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        counterLabel = self.childNode(withName: "counterLabel") as? SKLabelNode

        FontManager.convertToHalogen(label: counterLabel, text: "\(completedQuestions)/\(questionCount + 1)", fontSize: 50, withColor: ColorManager.neonGreen)

        
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
        
        //Give out enter boxes name for detection later
        enterNodes[0].name = "enterNode1"
        enterNodes[1].name = "enterNode2"
        
        //Place them close to each other.
        enterNodes[0].position.x = self.frame.midX - enterNodes[0].frame.width + 10
        enterNodes[1].position.x = self.frame.midX + enterNodes[1].frame.width - 10
        
        //Add them to our view
        enterNodes.forEach{ node in
            self.addChild(node)
        }
        
        self.setupNumbers()
        
    }
    
    //If the number intersects with one of our important elements, we return true, indicating to the caller to choose a new position.
    func numberIntersectsWithImportantObjects(_ answerLabel: SKLabelNode) -> Bool{
        return self.potentialAnswers.contains(where: {$0.frame.intersects(answerLabel.frame)}) ||
            self.enterNodes.contains(where: {$0.frame.intersects(answerLabel.frame)}) ||
            (self.questionLabel?.frame.contains(answerLabel.frame) ?? false)
    }
    
    func setupNumbers(){
        //Remove all existing numbers
        potentialAnswers.forEach {num in
            num.removeFromParent()
        }
        potentialAnswers.removeAll()
        
        //Generate a new number pair
        firstNumber = Int.random(in: 2 ... 9)
        secondNumber = Int.random(in: 2 ... 9)
        
        //Construct our label with our new numbers
        FontManager.convertToHalogen(label: questionLabel, text: "What is \(firstNumber) times \(secondNumber)?", fontSize: 60, withColor: ColorManager.neonBlue)

        //Add each number to our view, randomly placed with no intersections with important objects or with other numbers.
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
    
    //When the users lets go of a node, we assign nil to draggingNode
    public override func mouseUp(with event: NSEvent) {
        draggingNode = nil
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let point = event.location(in: self)
        //If let our node equal our currently dragged node (or the first other node if that fails)
        if let hitNode = draggingNode ?? self.nodes(at: point).first as? SKLabelNode {
            //Keep track of the dragged node
            draggingNode = hitNode
            //So long as our node is not one of the important ones
            if !( ((hitNode.name?.contains("enter")) ?? false) || ((hitNode.name?.contains("back")) ?? false) || ((hitNode.name?.contains("question")) ?? false)){
                let newPoint = CGPoint(x: point.x, y: point.y - (hitNode.frame.height / 2))
                var snapped = false
                
                //We check with each enterBox if the correct number is being dropped into it.
                for (index, enterNode) in enterNodes.enumerated(){
                    if enterNode.frame.contains(hitNode.frame){
                        snapped = true
                        
                        //First enter box
                        if index == 0{
                            
                            if hitNode.attributedText?.string == String(correctAnswer.first!){
                                //Place the number in the center of the enter box
                                hitNode.position = CGPoint(x: enterNode.frame.midX, y: enterNode.frame.midY - (hitNode.frame.height / 2 ))
                                //If it's the right number we make it green.
                                FontManager.convertToHalogen(label: hitNode, text: String(correctAnswer.first!), fontSize: 80, withColor: ColorManager.neonGreen)
                                correctFirstNumber = true
                                if correctAnswer.count == 1{ //If the answer is a single digit, we use this to make sure the user can proceed.
                                    correctSecondNumber = true
                                }
                            } else {
                                //If it's not the right number, we make it red.
                                FontManager.convertToHalogen(label: hitNode, text: hitNode.attributedText!.string, fontSize: 80, withColor: ColorManager.neonRed)
                                hitNode.position = newPoint
                                
                            }
                        }
                        //Second enter box
                        if index == 1{
                            
                            if hitNode.attributedText?.string == String(correctAnswer.last!){
                                //Place the number in the center of the enter box
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
                            //If it's not snapped, we convert it back to white
                            FontManager.convertToHalogen(label: hitNode, text: hitNode.attributedText!.string, fontSize: 80, withColor: ColorManager.neonWhite)
                            hitNode.position = newPoint
                        }
                    }
                    //IF the user has both numbers correct and hasn't already finished, we check if there are any questions left.
                    if correctFirstNumber && correctSecondNumber && !finished{
                        
                        
                        
                        //IF there are more questions, we generate a new one
                        if completedQuestions <= questionCount && !processing{
                            processing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                                self.finished = false
                                self.completedQuestions += 1
                                
                                self.setupNumbers()
                                
                                self.correctFirstNumber = false
                                self.correctSecondNumber = false
                                self.processing = false
                                
                            })
                        } else {
                            //Otherwise, we quit the level.
                            if completedQuestions >= questionCount{
                               self.userDidFinishLevel(1)
                            }
                        }
                    }
                }
            }
        }
    }
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let hitNodes = self.nodes(at: point)
        
        //If the user clicks the back button, quit
        if hitNodes.contains(where: {$0.name == "backButton"}){
            quit()
        }
        
    }
    public var userDidFinishLevel: (Int) -> Void = {level in}
    
    //Define a closure to quit, which is overwritten when the class is instantiated.
    public var quit: () -> Void = {}
    
}
