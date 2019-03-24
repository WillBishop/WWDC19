import Foundation
import SpriteKit

//Construct an enum which contains the name of every Australian state (Tasmania excluded as it is seperate).
//  - Adopting `String` means we can use `state.rawValue` to get a string representation of every element. This is used for nodes and file names.
//  - Adopting `CaseIterable` means we can construct an array of all cases with `state.allCases`.
public enum state: String, CaseIterable{
    case newsouthwales
    case queensland
    case northenterritory
    case southaustralia
    case westernaustralia
    case victoria
}
public class LevelFiveScene: SKScene{
    
    private var backButton: SKLabelNode?
    private var questionLabel: SKLabelNode?
    
    //We keep track of our selected node for easy dragging. It's an optional value because the user may not be dragging any node at any given time.
    var selectedNode: SKNode?
    
    //All our states are stored in an array for future checking (when dragging).
    var states = [SKShapeNode]()
    
    //All of our states are stored in the aptly named `stateNodes`
    var stateNames = state.allCases
    
    //stateNodes is a computed read-only variable which returns all sprites on the screen (which are all state nodes)
    var stateNodes: [SKSpriteNode]{
        get{
            return self.children.compactMap {$0 as? SKSpriteNode}
        }
    }
    
    //This represents the nodes which each state will snap too. The nodes can be looked up with stateSnapNodes[state].
    var stateSnapNodes: [state: SKSpriteNode]{
        get{
            //We create an identical array.
            var mappedNode = [state: SKSpriteNode]()
            
            //For every state defined
            for st in stateNames{
                //We find each node with a st.rawValue (which returns a string) then add 'Node' (configured in Level5.sks)
                //If we can't find one, we `continue` until the next one. We co this instead of return in order to continute trying to find nodes.
                guard let node = self.childNode(withName: st.rawValue + "Node") else {continue}
                
                //Unwrap it to be sure it exists
                guard let sprite = node as? SKSpriteNode else {continue}
                //Add it to our array.
                mappedNode[st] = sprite
            }
            return mappedNode
        }
    }
    
    var snappedNodes = [SKNode]()
    
    //Elements which can't be dragged or have elements on top of or beneath.
    var importantElements = ["back", "question", "outline"]
    
    
    public override func didMove(to view: SKView) {
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        
        //Convert our labels to halogen
        FontManager.convertToHalogen(
            label: backButton,
            text: "< Back",
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        FontManager.convertToHalogen(
            label: questionLabel,
            text: "Can you piece Australia together?",
            fontSize: 50,
            withColor: ColorManager.neonBlue
        )
        
        
    }
    
    func executeAfter(_ seconds: Double, code: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            code()
        })
    }
    
    //When the user released the mouse, they 'drop' any potential node, so we set it to nil
    public override func mouseUp(with event: NSEvent) {
        self.selectedNode = nil
    }
    
    //This function handles the user dragging states around.
    public override func mouseDragged(with event: NSEvent) {
        let position = event.location(in: self)
        let nodes = self.nodes(at: position)
        //We iterate over every node at the mouse point
        for potentialNode in nodes{
            let node = self.selectedNode ?? potentialNode //We use this to use the selectedNode if one exists, otherwise we use the `potentialNode` variable in our for loop.
            guard let name = node.name else {continue} //Ensure it has a name, otherwise don't do anything with it.
            guard let stateO = state(rawValue: name) else {continue} //Ensure we can struct a state case from it.
            guard let snapNode = stateSnapNodes[stateO] else {continue} //Ensure we can find our snap node.
            
            //If all of the above succeeds, we can confirm we've picked up a valid node and can assign it to our selectedNode variable, ensuring no other node is interacted with.
            self.selectedNode = node
            
            //If our snap node contains the position of our mouse, we can snap it into place
            if snapNode.frame.contains(position){
                
                
                //Move our node to the snapNode position.
                node.position = snapNode.position
                
                //Append our node to snappedNodes if it's not already in there.
                if self.snappedNodes.firstIndex(of: node) == nil{
                    self.snappedNodes.append(node)
                }
            } else { //If our snap node does not contain the mouse position.
                //If it's in our snappedNodes array, remove it.
                if let existingIndex = self.snappedNodes.firstIndex(of: node){
                    self.snappedNodes.remove(at: existingIndex)
                }
                //Move our node to our mouses position.
                node.position = position
            }
            
        }
        //If the number of snappedNodes equals the total number of states, the user has completed the level.
        if snappedNodes.count == stateNames.count{
            self.userDidFinishLevel(5)
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
