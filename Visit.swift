//
//  Visit.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/18/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class ChildParent {

    var child: [String]
    
    var parent: ChildParent?
    
    init(child: [String], parent: ChildParent?)
    {
        self.child = child
        self.parent = parent
    }
    func getChild() -> [String]
    {
        return self.child
    }
    func getParent() -> ChildParent?
    {
        if self.parent == nil
        {
            return nil
        }
        return self.parent!
    }
    func setChild(new_child: [String])
    {
        self.child = new_child
    }
    func setParent(new_parent: ChildParent?)
    {
        self.parent = new_parent
    }
    func equal(object1: ChildParent?, object2: ChildParent?) -> Bool
    {
        return object1?.child == object2?.child &&
                object1?.parent == object2?.parent
    }
}
extension ChildParent: Equatable {
    static func == (lhs: ChildParent, rhs: ChildParent) -> Bool {
        return lhs.child == rhs.child &&
               lhs.parent == rhs.parent
        }
    }

class NextStatePackage {

    var bottom_of_shortened_stack: ChildParent
    
    var next_states: [[String]]
    var indents: Int
    init(bottom_of_shortened_stack: ChildParent, next_states: [[String]], indents: Int)
    {
        self.bottom_of_shortened_stack = bottom_of_shortened_stack
        self.next_states = next_states
        self.indents = indents
    }
    func getBottomOfShortenedStack() -> ChildParent
    {
        return self.bottom_of_shortened_stack
    }
    func setBottomOfShortenedStack(bottom_of_shortened_stack: ChildParent)
    {
        self.bottom_of_shortened_stack = bottom_of_shortened_stack
    }
    func setNextStates(next_states: [[String]])
    {
        self.next_states = next_states
    }
}

class Visit {

    var next_states:        [[String]]
    
    var current_state_name: [String]
    
    var end_state_name:     [String]
    
    var bottom:             ChildParent
    
    var bottom_tracker:     ChildParent
    
    var dummy_node:         ContextState
    
    var state_point_table:  [[String]: Point]
    
    var levels:             [Point: ContextState]
    
    var ii:                 Int
    var indents:            Int
    
    init(next_states:           [[String]],
         current_state_name:    [String],
         bottom:                ChildParent,
         dummy_node:            ContextState,
         state_point_table:     [[String]: Point],
         levels:                [Point: ContextState])
    {
    
        self.next_states        =   next_states
        self.current_state_name =   current_state_name
        self.bottom             =   bottom
        self.bottom_tracker     =   bottom
        self.dummy_node         =   dummy_node
        self.state_point_table  =   state_point_table
        self.levels             =   levels
        self.ii                 =   Int()
        self.indents            =   Int()
        self.end_state_name     =   [String]()

    }
    func getNextStates(bottom:              ChildParent,
                       next_states:         [[String]],
                       indents:             Int,
                       state_point_table:   [[String]: Point],
                       levels:              [Point: ContextState]) -> NextStatePackage
    {
        //print("in stack shrink")
        // the stack is a reversed linked list
        // goes up the stack and finds the next set of next states
        // will erase the progress of any bottom up branches connected to the node popped
        // only pop if the current path is the only path
        // if there is more than 1 path, reset where the bottom tracker is
        var indents2: Int = indents
        let return_package: NextStatePackage = NextStatePackage.init(bottom_of_shortened_stack: bottom,
                                                                     next_states:               next_states,
                                                                     indents:                   indents2)
        var state: [String] = return_package.getBottomOfShortenedStack().getChild()
        while(!(return_package.getBottomOfShortenedStack().getParent() == nil) &&
                return_package.next_states.count == 0)
        {
            // maybe .decrementIndents?
            indents2 -= 1
            return_package.setBottomOfShortenedStack(bottom_of_shortened_stack: return_package.getBottomOfShortenedStack().getParent()!)
            state = return_package.getBottomOfShortenedStack().getChild()
            if(state[0] == "root" )
            {
                return_package.setNextStates(next_states: [])
                //print("end of stack shrink")

                return return_package
            }
            
            let state_location: Point = state_point_table[state]!
            return_package.setNextStates(next_states: (levels[state_location]?.getNexts())!)
            //printStack2(bottom_tracker: return_package.getBottomOfShortenedStack())
        }
        //print("end of stack shrink")

        return return_package
        
    }
    func isParent(maybe_parent: Int) -> Bool
    {
    
        return maybe_parent > 0
    }
    func isBottomAtTheParentOfCurrentState(parents: [[String]],
                                           bottom_state: [String]) -> Bool
    {
        // assume that each state can have multiple parents, but only 1 of those parents is in use from the child's perspective
        for parent in parents
        {
            let ith_parent_point: Point = self.state_point_table[parent]!
            let bottom_state_point: Point = self.state_point_table[bottom_state]!
            
            if(ith_parent_point.getLevelId() == bottom_state_point.getLevelId() &&
               ith_parent_point.getStateId() == bottom_state_point.getStateId())
            {
                return true
            }
        }
        return false
    }
    func hasParent(levels: [Point: ContextState], point: Point) -> Bool
    {
        return (levels[point]?.getParents().count)! > 0
    }
    func printStack2(bottom_tracker: ChildParent?)
    {
        print("stack\n")
        var bottom_tracker2 = self.bottom_tracker
        
        // still might not work
        // tracker's parent != nil
        
        while(!(bottom_tracker2.getParent() == nil))
        {
            print(bottom_tracker2.getChild())
            //print("|")
            bottom_tracker2 = bottom_tracker2.getParent()!
        }
        // last item
        print(bottom_tracker2.getChild())

        print("\n")
        
    }

    func visitStates(start_state: ContextState, end_state: ContextState)
    {
        // the user will have to make a map from state to function
        // set current state to start_state
        // keep going untill an end state is reached (error), or end_state is reached (success)
        
        self.current_state_name = start_state.getName()
        self.end_state_name = end_state.getName()
        // https://useyourloaf.com/blog/swift-hashable/
        // when the end state is checked in the loop guard, end state machine
        let end_states_nexts = [self.end_state_name]//end_state.getNexts()
        //print(end_state.getNexts())
        //exit(1)
        self.bottom_tracker = self.bottom
        self.state_point_table[self.dummy_node.name] = Point.init(l: -1, s: -1)
        
        while(self.next_states != end_states_nexts)
        {
            print("at", self.ii)
            if(ii == 15)
            {
                print("too many states run\n")
                exit(1)
            }
            var state_changed: Bool = false
            var j: Int = Int()
            //print("current state")
            //print(self.next_states[0])
            //print()
            //print(self.next_states)
            // map each self.current_state_name to a bool result
            // save all true results
            // run the hasParent... on the set of true results
            while(j < self.next_states.count)
            {
                // how to let it run multiple true states?
                self.current_state_name = self.next_states[j]
                //print("trying state")
                //print(self.current_state_name)
                // there should always be an entry in the table that is gettin indexed
                let point: Point = self.state_point_table[self.current_state_name]!
                
                let maybe_parent: Int = (levels[point]?.getStartChildren().count)!
                //print("running", levels[point]?.function_name)
                let did_function_pass: Bool = (levels[point]?.callFunction(current_state_name: self.current_state_name))!
                if(did_function_pass)
                {
                    if(hasParent(levels: self.levels, point: point))
                    {
                        let bottom_state: [String] = self.bottom_tracker.getChild()
                        let parents: [[String]] = (self.levels[point]?.getParents())!
                        if(isBottomAtTheParentOfCurrentState(parents:       parents,
                                                             bottom_state:  bottom_state))
                        {
                            let new_parent: ChildParent = ChildParent.init(child: self.current_state_name,
                                                                           parent: self.bottom_tracker)
                            self.bottom_tracker = new_parent
                            self.indents += 1
                        }
                    }
                    if(isParent(maybe_parent: maybe_parent))
                    {
                        self.bottom_tracker.setChild(new_child: self.current_state_name)
                        let start_children: [[String]] = (self.levels[point]?.getStartChildren())!
                        self.next_states = []
                        for start_child in start_children
                        {
                            self.next_states.append(start_child)
                        }
                    }
                    else
                    {
                        let nexts:[[String]] = (self.levels[point]?.getNexts())!
                        self.next_states = []
                        for next_state in nexts
                        {
                            self.next_states.append(next_state)
                        }
                        self.bottom_tracker.setChild(new_child: self.current_state_name)
                    }
                    state_changed = true
                    break
                }
                j += 1
            }
            //print("state changed?", state_changed)
           // print("stack")
            //print("winning state1 ", self.current_state_name)
            //print("next states")
            //print(self.next_states)
            printStack2(bottom_tracker: self.bottom_tracker)
            
            
            if(self.next_states.count == 0)
            {
            
            
                //print("time to shorten stack\n")
                let tracker_continuing_next_states_indents: NextStatePackage = getNextStates(bottom: self.bottom_tracker,
                                                                                             next_states: self.next_states,
                                                                                             indents: self.indents,
                                                                                             state_point_table: self.state_point_table,
                                                                                             levels: self.levels)
                self.next_states = tracker_continuing_next_states_indents.next_states
                self.indents = tracker_continuing_next_states_indents.indents
                self.bottom = tracker_continuing_next_states_indents.bottom_of_shortened_stack
                self.bottom_tracker = self.bottom
                //print("shortened stack")
                //printStack2(bottom_tracker: self.bottom_tracker)
                //print(self.next_states)
            }
            if(!state_changed && self.next_states.count > 0)
            {
                print("error at ")
                print(self.next_states)
                break
                /*
                            //printf(getIndents(indents), next_states, "on");
            level_id_state_id* point = ht_search2(state_x_y_table, current_state_name);

            //printf(getIndents(indents), '('+  '\'' + current_state_name + '\'' + ',' , case_ + ',', "f=" +
            //       levels[point->level_id].state_list[point->state_id]->function_name + ',', str(indents) + ')');
            break;

            //print(next_states, 'have failed so your state machine is incomplete')
            //exit()

                */
            }
            //print("winning state2", self.current_state_name)
            //print("next states")
            //print(self.next_states)
            //print("end condition")
            //print(end_states_nexts)
            
            self.ii += 1
        }
        print("state machine is done\n")
        exit(1)
        // while not at end_state's nexts
    }
}
