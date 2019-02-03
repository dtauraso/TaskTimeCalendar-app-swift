//
//  Parser.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
class Parser {
    
    var name_state_table: [[String]: ContextState] = [[String]: ContextState]()
    func getState(state_name: [String]) -> ContextState
    {
        return retrieveState(current_state_name: state_name, name_state_table: &name_state_table)
    }
    func getVariable(state_name: [String]) -> Data
    {
        return retrieveState(current_state_name: state_name, name_state_table: &name_state_table).getData()
    }
    func saveState(state: ContextState)
    {
        self.name_state_table[state.getName()] = state

    }
    func getContextStateFromStringListToContextStateEntry(key: [String]) -> ContextState
    {
        let entry = self.name_state_table[key]
        if(entry != nil)
        {
            return entry!
        }
        return ContextState.init(name: [], function: returnTrue)
    }
    
    
    
    

    func testing(current_state_name: [String], parser: inout Parser) -> Bool
    {
        let test: String = parser.name_state_table[current_state_name]!.getData().getString()
        //print(test)
        return true
    }

   
}
 func runParser()
{
    let name_state_table = [[String]: ContextState]()

    let visitor_class: Visit = Visit.init(next_states: [["states", "state"]],
                                              current_state_name:    ["states", "state"],
                                              bottom:                ChildParent.init(child: ["root", "0"],
                                                                                      parent: nil),
                                              dummy_node:            ContextState.init(name:["root", "0"],
                                                                                       nexts: [],
                                                                                       start_children: [],
                                                                                       function: returnTrue(current_state_name:parser:),
                                                                                       function_name: "returnTrue",
                                                                                       data: Data.init(new_data: [:]),
                                                                                       parents: []),
                                              name_state_table:     name_state_table)
var parser: Parser = Parser.init()
        // visitStatesParser(start_state:)
//visitor_class.visitStates(start_state: name_state_table[["states", "state"]]!, parser: &parser)

}
func setState(current_state: ContextState, name_state_table: inout [[String]: ContextState])
{
    name_state_table[current_state.getName()] = current_state

}
//            getState(current_state_name: ["i"]).getData().setInt(value: -1)

func retrieveState(current_state_name: [String], name_state_table: inout [[String]: ContextState]) -> ContextState
{
    if(name_state_table[current_state_name] != nil)
    {
        return name_state_table[current_state_name]!

    }
    print("no state by ", current_state_name, "is in name_state_table")
    //exit(0)
    return ContextState.init(name: ["state does not exist"], function: returnTrue(current_state_name: parser:))
}
func setData(current_state_name: [String], name_state_table: inout [[String]: ContextState], data: Int)
{
    if(name_state_table[current_state_name] != nil)
    {
        
        name_state_table[current_state_name]?.getData().setInt(value: data)
    }
}


// functions for the parser
func advanceInit(current_state_name: [String], parser: inout Parser) -> Bool
{
    /*
        level_number
        state_id
        prev_indent
        prev_word
        current_word
        next_indent
        i
        what_is_current_word_to_prev_word
            child
            sibling
            parent
     
        // level_indent_stack
            // 0, 1, 2
            // level_number
                // 0, 1, 2
            // indent_number
                // 0, 1, 2

        // 0, 0
        // 1, 2
    */
    //print("in here")
    //print(getState(current_state_name: ["level_number"]).getInt())
    //print(getState(current_state_name: ["i"]).getInt())
    var i: Int = parser.getVariable(state_name: ["i"]).getInt()
    let input: String = parser.getVariable(state_name: ["input"]).getString()
    var index = input.index(input.startIndex, offsetBy: 0)

    //print(input)
    var word: String = String()
    
    while(input[index] != "\n")
    {
        word.append(input[index])
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
    }
    //print(word)
    //print(getState(current_state_name: ["i"]).getInt())
    //print(getState(current_state_name: ["current_word"]).getString())
    //print("|" + String(input[index]) + "|")
    index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))

    var indent_count: Int = Int()
    while(input[index] == "\t")
    {
        
        indent_count += 1
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
        
    }
    //print(indent_count)
    //print(input[index])
    i = index.encodedOffset
    //setData(current_state_name: ["i"], data: i)
    parser.getVariable(state_name: ["i"]).setInt(value: i)
    //parser.saveState(state: )
    parser.getVariable(state_name: ["current_word"]).setString(value: word)
    //getState(current_state_name: ["i"], name_state_table: &name_state_table).getData().setInt(value: i)
    //getState(current_state_name: ["current_word"], name_state_table: &name_state_table).getData().setString(value: word)

    //print(indent_count)
    parser.getVariable(state_name: ["next_indent"]).setInt(value: indent_count)
    //getState(current_state_name: ["next_indent"], name_state_table: &name_state_table).getData().setInt(value: indent_count)
    //print(getState(current_state_name: ["next_indent"]).getInt())
    //print(word)
    //exit(0)
    
    return true
}
func collectName(current_state_name: [String], parser: inout Parser) -> Bool
{
    //print("collectName")
    //print(getState(current_state_name: ["current_word"]).getString())
    let state_name_progress = parser.getVariable(state_name: ["current_word"]).getString()
    //print(state_name_progress)
    //print( getState(current_state_name: ["name", "state_name"]).getStringList())
    parser.getVariable(state_name: ["name", "state_name"]).appendString(value: state_name_progress)
    //getState(current_state_name: ["name", "state_name"], name_state_table: &name_state_table).getData().appendString(value: state_name_progress)
    //print(parser.getVariable(state_name: ["name", "state_name"]).getStringList())
    //exit(0)
    
    return true
}
func advanceLoop(current_state_name: [String], parser: inout Parser) -> Bool
{
    // i is pointing to the
    //print("in advanceLoop")
    var i: Int = parser.getVariable(state_name: ["i"]).getInt()
    let input: String = parser.getVariable(state_name: ["input"]).getString()
    var next_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    var prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    var current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var prev_word = parser.getVariable(state_name: ["prev_word"]).getString()
    var index = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
    parser.getVariable(state_name: ["prev_prev_indent"]).setInt(value: prev_indent)
    // input[index] is not supposed to = '\n'
    if(index.encodedOffset >= input.count)
    {
        return false
        //print("|", input[index], "|")

    }
    print("prev word", "current_word")
    print(prev_word, current_word)
    print(prev_indent, next_indent)
    var word: String = String()
    if(index.encodedOffset + 1 >= input.count)
    {
        print("done")
        exit(0)
    }
    while(index.encodedOffset < input.count && input[index] != "\n")
    {
        if(index.encodedOffset >= input.count)
        {
            return false
        }
        word.append(input[index])
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
    }
    
    //print(index.encodedOffset)
    //print(word)
    
    // end of file so save the function name
    if(index.encodedOffset + 1 >= input.count)
    {
        parser.getVariable(state_name: ["i"]).setInt(value: -1)
        //getState(current_state_name: ["i"], name_state_table: &name_state_table).getData().setInt(value: -1)
        //print(word)
        parser.getVariable(state_name: ["current_word"]).setString(value: word)
        //print("last round")
        //print(parser.getVariable(state_name: ["current_word"]).getString())
        
        //getState(current_state_name: ["current_word"], name_state_table: &name_state_table).getData().setString(value: word)
        //print(current_state_name)
        // need to visit a final check and then save the last function
        // set TLO to true
        parser.getVariable(state_name: ["tlo"]).setBool(value: true)
        //parser.getVariable(state_name: ["i"]).setInt(value: 0)
        //saveFunctionName(current_state_name: current_state_name, parser: &parser)
        return true//false
    }
    index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
    //print(index.encodedOffset)
    var indent_count: Int = Int()
    while(index.encodedOffset < input.count && input[index] == "\t")
    {
        if(index.encodedOffset >= input.count)
        {
            return false
        }
        indent_count += 1
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
        
    }
    //print(index.encodedOffset)
    // setup what_is_current_word_to_pre_word member variables
    parser.getVariable(state_name: ["child"]).setBool(value: false)
    //getState(current_state_name: ["child"], name_state_table: &name_state_table).getData().setBool(value: false)
    parser.getVariable(state_name: ["sibling"]).setBool(value: false)
    //getState(current_state_name: ["sibling"], name_state_table: &name_state_table).getData().setBool(value: false)
    parser.getVariable(state_name: ["new_parent"]).setBool(value: false)
    //getState(current_state_name: ["new_parent"], name_state_table: &name_state_table).getData().setBool(value: false)

    if(prev_indent < next_indent)
    {
        parser.getVariable(state_name: ["child"]).setBool(value: true)

        //getState(current_state_name: ["child"]).getData().setBool(value: true)
    }
    else if(prev_indent == next_indent)
    {
        parser.getVariable(state_name: ["sibling"]).setBool(value: true)
        //getState(current_state_name: ["sibling"], name_state_table: &name_state_table).getData().setBool(value: true)
    }
    else if(prev_indent > next_indent)
    {
        parser.getVariable(state_name: ["new_parent"]).setBool(value: true)
        //getState(current_state_name:["new_parent"], name_state_table: &name_state_table).getData().setBool(value: true)
        //print(true)
    }
    //print(prev_indent, next_indent)
    swap(&next_indent, &prev_indent)
    swap(&current_word, &prev_word)
    current_word = word
    print("prev word, current word")
    print(prev_word, current_word)
    //print(indent_count)
    next_indent = indent_count
    //print("i", i)

    i = index.encodedOffset
    
    //print(i)
    print(prev_indent, next_indent)
    //setData(current_state_name: ["i"], data: i)
    parser.getVariable(state_name: ["i"]).setInt(value: i)
    //getState(current_state_name: ["i"], name_state_table: &name_state_table).getData().setInt(value: i)
    parser.getVariable(state_name: ["prev_word"]).setString(value: prev_word)
    //getState(current_state_name: ["prev_word"], name_state_table: &name_state_table).getData().setString(value: prev_word)

    parser.getVariable(state_name: ["current_word"]).setString(value: current_word)
    //getState(current_state_name: ["current_word"], name_state_table: &name_state_table).getData().setString(value: current_word)
    
    parser.getVariable(state_name: ["prev_indent"]).setInt(value: prev_indent)
    //getState(current_state_name: ["prev_indent"], name_state_table: &name_state_table).getData().setInt(value: prev_indent)

    parser.getVariable(state_name: ["next_indent"]).setInt(value: next_indent)
    //getState(current_state_name: ["next_indent"], name_state_table: &name_state_table).getData().setInt(value: next_indent)

    //print(getState(current_state_name: ["i"]).getData().getInt())
    //print(parser.getVariable(state_name: ["prev_word"]).getString(), parser.getVariable(state_name: ["current_word"]).getString())
    
    //print(parser.getVariable(state_name: ["prev_indent"]).getInt(), parser.getVariable(state_name: ["next_indent"]).getInt())
    let x = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    //print(parser.getVariable(state_name: ["indent_number", String(x)]).getInt())
    if(index.encodedOffset < input.count)
    {
        //print("|", input[index], "|")

    }
    //print("current stack")
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    /*
    for i in (0...max_stack_index)
    {
        print("level, state")
        print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
     
        print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
        print()
    }*/
    //exit(0)
    return true
}
func endOfInput(current_state_name: [String], parser: inout Parser) -> Bool
{
    // advance loop from "advance past \"Data\"" pushed j past the point of the input
    // so now
    let input = parser.getVariable(state_name: ["input"]).getString()

    let j = parser.getVariable(state_name: ["i"]).getInt()
    print(j, input.count)
    return j == -1// >= input.count - 2
}
func tlo(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["tlo"]).getBool()
}
func isDeadState(current_state_name: [String], parser: inout Parser) -> Bool
{
    //print("is in dead state")
    let next_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    //print(next_indent == prev_indent)
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let prev_word = parser.getVariable(state_name: ["prev_word"]).getString()
    //print("prev word, current word")
    //print("|", prev_word, "|", "|", current_word, "|")
    
    if(current_word == "")
    {
        print("end of input")
        parser.getVariable(state_name: ["tlo"]).setBool(value: true)
        return true

    }
    return next_indent == prev_indent
}
func isData(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Data"

}
func isChildren(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Children"

}
func isNext(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Next"

}
func isCurrentWordFunction(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["current_word"]).getString() == "Function"

}
func saveState(current_state_name: [String], parser: inout Parser) -> Bool
{
    //print("saveNewState")
    // if at any other state, have to set it's parent to the last state saved and the last state saved's first children
    // if there is more than 1 child, do the above for the first child only
    
    // does not work for more than 1 parent
    var collected_state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    let last_item = collected_state_name.count - 1

    let start_index = collected_state_name[last_item].startIndex
    var collected_state_name2 = [String]()
    for i in collected_state_name
    {
        collected_state_name2.append(i)
    }
    if(collected_state_name[last_item][start_index] == "-")
    {
        collected_state_name2[last_item] = String(collected_state_name2[last_item].dropFirst())
    }
    //print(getState(current_state_name: ["name", "state_name"]).getData().getStringList())
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()
    //print(level)
    let state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    // level_id and state_id are the top of the stack
    // the stack should have the current level, current indent level for state, ith state
    //print(state)
    //print(getState(current_state_name: ["child"]).getData().getBool())

    let new_state = ContextState.init(name: collected_state_name2, function: returnTrue(current_state_name: parser:))
    if(current_state_name == ["save dead state"])
    {
        new_state.setFunctionName(function_name: "returnTrue")
    }
    // point_table "[[String]: Point]"
    parser.getVariable(state_name: ["point_table"]).setStringListToPointEntry(key: collected_state_name2,
                                                                              value: Point.init(l: level, s: state))
    //getState(current_state_name: ["point_table"], name_state_table: &name_state_table).getData().setStringListToPointEntry(key: collected_state_name2,
    //                                                                                  value: Point.init(l: level, s: state))

    
    // sparse_matrix "[Point: ContextState]"
    parser.getVariable(state_name: ["sparse_matrix"]).setPointToContextState(key: Point.init(l: level, s: state),
                                                                             value: new_state)
    //getState(current_state_name: ["sparse_matrix"], name_state_table: &name_state_table).getData().setPointToContextState(key: Point.init(l: level, s: state),
    //                                                                                 value: new_state)
    
    
    if(level == 0 && state == 0)
    {
            // if at first state(0, 0), have to set it's parent and root's start children
            //print("here", collected_state_name)
        let point: Point = Point.init(l: 0, s: 0)

        let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
            //print("origin state", state.getName())
            state.setParents(parents: [["root"]])
            //state.Print(indent_level: 0)

            //exit(0)
        

    }
    // for when same level is reentered later in the tree
    else// if (state >= 0)
    {
        
        
        let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
        let prev_level_state_number = parser.getVariable(state_name: ["state_number", String(max_stack_index - 1)]).getInt()
        
        let prev_level_level_number = parser.getVariable(state_name: ["level_number", String(max_stack_index - 1)]).getInt()
        //print("prev level things")
        //print(prev_level_level_number, prev_level_state_number)
        let point: Point = Point.init(l: prev_level_level_number, s: prev_level_state_number)
        
        let parent_state: ContextState = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
        let start_index = collected_state_name[last_item].startIndex
        if(collected_state_name[last_item][start_index] == "-")
        {
            collected_state_name[last_item] = String(collected_state_name[last_item].dropFirst())
            parent_state.appendStartChild(start_child: collected_state_name)
        }
        else
        {
            
            parent_state.appendChild(child: collected_state_name)
        }
        //parent_state.setStartChildren(start_children: [collected_state_name])
        // when the other children are being added to the parent's list the last one is replaced with the next one
        
        // can't tell the different's between children next states and children of the lower level
        // use a "-" right before the name of the child state so the start children and the other children can be told apart without breaking a big chunk of the graph
        // also, making a big change in the structure just to tell a few states apart is way too distracting
        // "-" is easier to tell them apart and read
        //parent_state.Print(indent_level: 0)

        //print("child location", level, state)
        //print()
        let location_of_child = Point.init(l: level, s: state)
        let child_state: ContextState = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: location_of_child)
        //print(child_state.getName())
        child_state.setParents(parents: [parent_state.getName()])


        //var current_state = getState(current_state_name: ["state_id"]).getData().getInt()
        
        //getState(current_state_name: ["state_number", String(max_stack_index)]).getData().setInt(value: current_level_state_number + 1)
        //getState(current_state_name: ["state_id"]).getData().setInt(value: current_state + 1)
        
        //print(max_stack_index, prev_level_state_number, prev_level_level_number)

        
        // can't assume the state in the higher level is the same as this one
        // the second to top item in the stack is the state value for the higher level
    }
    
    
    
    // print saved state
    let point = parser.getVariable(state_name: ["point_table"]).getPointFromStringListToPointEntry(key: collected_state_name)
    //print("point")
    //point.Print()

    let context_state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: point)
    
    context_state.Print(indent_level: level)
    //print()
    //print()
    //exit(0)
    //print()
    return true
    
}
func saveNewState(current_state_name: [String], parser: inout Parser) -> Bool
{
    saveState(current_state_name: current_state_name, parser: &parser)
    //getState(current_state_name: ["name", "state_name"]).getData().setStringList(value: [])
    let state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    let x = state_name.dropLast()
    var new_state_name = [String]()
    for i in x
    {
        new_state_name.append(i)
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: new_state_name)
    let matrix = parser.getVariable(state_name: ["sparse_matrix"]).data["[Point: ContextState]"] as! [Point: ContextState]
    //print(matrix.count)
    return true
}
func advanceLevel(current_state_name: [String], parser: inout Parser) -> Bool
{
    //print("advance level")

    
    // take the current level and state values from the tracker and use them to calculate secondary name for stack variables, location of stack veriables in the levels matrix
    // does depth first traversal using the level id's
    // does breath first traversal using the state id's
    var max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    //print("current stack")
    /*
    for i in (0...max_stack_index)
    {
        print("level, state")
        print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
     
        print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
        print()
    }*/
    
    //print(getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt())
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()
    //print("level_number")
    //print(getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt())
    
    //print("state level_number")
    //print(getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt())
    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()

    /*
     // level_indent_stack
            // 0, 1, 2
            // level_number
                // 0, 1, 2
            // indent_number
                // 0, 1, 2
    */
    //print("data for stack")
    //print(getState(current_state_name: ["level_id"]).getData().getInt())

    //print(getState(current_state_name: ["prev_indent"]).getData().getInt())
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    
    /*
    print("first level")
    //start_index_in_level_for_stack_indexes
    print(getState(current_state_name: ["level_number", "0"]).getData().getInt())
    print(getState(current_state_name: ["state_number", "0"]).getData().getInt())
    print(getState(current_state_name: ["indent_number", "0"]).getData().getInt())
    */
    //var max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt() // 0
    //var start_index_in_level_for_stack_indexes = 30//getState(current_state_name: ["start_index_in_level_for_stack_indexes"]).getData().getInt()
    
    //let level_number_i_state_id = name_state_table[["level_number", String(max_stack_index)]]!
    //let level_number_i_state_id = level_number_i_point.getStateId() // 30
    
    //let state_number_i_state_id = name_state_table[["state_number", String(max_stack_index)]]!
    //let state_number_i_state_id = state_number_i_point.getStateId() // 31
    
    //let indent_number_i_state_id: Point = name_state_table[["indent_number", String(max_stack_index)]]!
    //let indent_number_i_state_id = indent_number_i_point.getStateId() // 32
    
    /*
    
    max stack index is the largest value any of the stack indexies can be
    start_index_in_level_for_stack_indexes is an arbitrary value set at a value beyond the states already in levels.  It is equal to 30
    */
    // (level_number, 0) is in level[30 + 0], (indent_number, 0) is in level[31 + 0]
    // (level_number, 1) = level[30 + 2], (indent_number, 1) = level[31 + 2]
    // level_number_i_state_id + 30 + 2 * (level_number_i_state_id)
    // 30, 32, 34, 36
    //  0,  1,  2,  3
    
    
    // 31, 33, 36
    //let new_point: Point = Point.init(l: 0, s: level_number_i_state_id + 30)
    // 1 * 2 + 32 = 34
    // 2 * 2 + 34
    let state: ContextState = parser.getContextStateFromStringListToContextStateEntry(key: ["state_number", String(max_stack_index + 1)])
    //print("push to stack: current_level, current_state, current_indent max_stack_index")
    //print(current_level, current_state, prev_indent, String(max_stack_index))
    // push
    if(state == ContextState.init(name: [], function: returnTrue))
    {
        max_stack_index += 1
        //let level_number_point: Point = Point.init(l: 0, s: level_number_i_state_id + 3)
        parser.name_state_table[["level_number", String(max_stack_index)]] = ContextState.init(name: ["level_number", String(max_stack_index)],
                                                                                             nexts: [],
                                                                                             start_children: [],
                                                                                             function: returnTrue(current_state_name:parser:),
                                                                                             function_name: "returnTrue",
                                                                                             data: Data.init(new_data: ["Int": current_level + 1]),
                                                                                             parents: [])
        //self.name_state_table[(self.levels[level_number_point]?.getName())!] = level_number_point

        //let state_number_point: Point = Point.init(l: 0, s: state_number_i_state_id + 3 )
        parser.name_state_table[["state_number", String(max_stack_index)]] = ContextState.init(name: ["state_number", String(max_stack_index)],
                                                                                             nexts: [],
                                                                                             start_children: [],
                                                                                             function: returnTrue(current_state_name:parser:),
                                                                                             function_name: "returnTrue",
                                                                                             data: Data.init(new_data: ["Int": 0]),
                                                                                             parents: [])
        //self.name_state_table[(self.levels[state_number_point]?.getName())!] = state_number_point

        //let indent_number_point: Point = Point.init(l: 0, s: indent_number_i_state_id + 3)
        parser.name_state_table[["indent_number", String(max_stack_index)]] = ContextState.init(name: ["indent_number", String(max_stack_index)],
                                                                                              nexts: [],
                                                                                              start_children: [],
                                                                                              function: returnTrue(current_state_name:parser:),
                                                                                              function_name: "returnTrue",
                                                                                              data: Data.init(new_data: ["Int": prev_indent]),
                                                                                              parents: [])
        //self.name_state_table[(self.levels[indent_number_point]?.getName())!] = indent_number_point
        
        // going down
        //getState(current_state_name: ["level_id"]).getData().setInt(value: current_level + 1)
        parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index)
        //print("pushed stack")
        /*
        for i in (0...max_stack_index)
        {
            print("level, state")
            print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
         
            print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
            print()
        }*/

    }
    // copy over
    else
    {
        //var hidden_stack_item: ContextState = self.na[point]!
        //let nth_level_pth_state = hidden_stack_item.getData().getInt()
        //hidden_stack_item.getData().setInt(value: nth_level_pth_state + 1)
        parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index + 1)
        let last_value = parser.getVariable(state_name: ["state_number", String(max_stack_index + 1)]).getInt()
        
        // increment state_number[max_stack_index + 1]
        parser.getVariable(state_name: ["state_number", String(max_stack_index + 1)]).setInt(value: last_value + 1)

        max_stack_index += 1
        /*
        print("copied stack")
        for i in (0...max_stack_index)
        {
            print("level, state")
            print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
         
            print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
            print()
        }*/

    }
    /*
    going across
    get the point of state_number, max_stack_index + 1
    works for pushing > 1 item and for backtracing > 1 items (a different state)
    if the point == -1, -1
        add (max_stack_index + 1)'s level_number, state_number, indent_number to the stack

    else
        (state_number, max_stack_index + 1).value = (state_number, max_stack_index + 1).value + 1
        max_stack_index += 1

    */
    // need the state id's in the levels to be distinct from the state's second name int value

    /*
    
    push (level, state) to stack if there are no next context values
    backtrack
    move back to already recorded level and use the data to modify the level to continue from the last time that level was visited
    
    */
    
    //getState(current_state_name: ["level_number", String(max_stack_index)]).getData().setInt(value: current_level)
    //getState(current_state_name: ["level_number", String(max_stack_index)]).getData().setInt(value: prev_level)
    print("pushed value")
    print(prev_indent)
    /*
    print("second level")
    //print(name_state_table[["level_number", "1"]]!.getStateId())
    //print(name_state_table[["state_number", "1"]]!.getStateId())
    //print(name_state_table[["indent_number", "1"]]!.getStateId())

    //print()
    print(getState(current_state_name: ["level_number", "1"]).getData().getInt())
    print(getState(current_state_name: ["state_number", "1"]).getData().getInt())
    print(getState(current_state_name: ["indent_number", "1"]).getData().getInt())
    
    print(getState(current_state_name: ["max_stack_index"]).getData().getInt())

    */
    
    
    //exit(0)
    return true
}

func saveNextStateLink(current_state_name: [String], parser: inout Parser) -> Bool
{
    
    //var next_state_links = getState(current_state_name: current_state_name).getData().getStringList()
    //print(next_state_links)
    //print(getState(current_state_name: ["current_word"]).getData().getString())
    //exit(0)
    /*
    let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    //print(getState(current_state_name: ["current_word"]).getData().getString())
    let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
    
    let current_level = getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt()
    //print("level id")
    //print(current_level)

    let current_state = getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt()
    //print("state id")
    //print(current_state)
    
    let state = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state))
    state.appendNextChild(next_child: [current_word])
    //state.Print(indent_level: 1)

    //state.getData().appendString(value: current_word)
    
    getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state)).Print(indent_level: 1)
    */
    return true
}
func initJ(current_state_name: [String], parser: inout Parser) -> Bool
{
    parser.getVariable(state_name: ["j"]).setInt(value: 0)
    parser.getVariable(state_name: ["names", "next state links"]).setStringList(value: [String]())
    return true
}
func initI(current_state_name: [String], parser: inout Parser) -> Bool
{
    //getState(current_state_name: ["j"]).getData().setInt(value: 0)
    parser.getVariable(state_name: ["state name string", "next states"]).setString(value: String())
    return true
}

func skipSpaces(input: String, i: Int) -> Int
{
    var k = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
    //print(input, k.encodedOffset)
    while(k.encodedOffset < input.count && input[k] == " ")
    {
        k = input.index(input.startIndex, offsetBy: String.IndexDistance(k.encodedOffset + 1))
    }
    return k.encodedOffset
}
func collectSpaces(input: String, i: Int) -> String
{
    var k = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
    var spaces = String()
    while(k.encodedOffset < input.count && input[k] == " ")
    {
        spaces.append(" ")
        k = input.index(input.startIndex, offsetBy: String.IndexDistance(k.encodedOffset + 1))
    }
    return spaces
}
func charNotBackSlashNotWhiteSpace(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    //j = skipSpaces(input: current_word, i: j)
    //print(current_word, j)
    if(j < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char != "\\" && char != " ")
        {
            var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
            state_name.append(char)
            parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)
            return true
        }
    }
    
    return false
    
}
func backSlash(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    let spaces = collectSpaces(input: current_word, i: j)
    if(j < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == "\\")
        {
            var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
            state_name.append(spaces)
            state_name.append(char)
            parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
    
    return false
}
func whiteSpace0(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    //j = skipSpaces(input: current_word, i: j)
    if(j < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == " ")
        {
            //var state_name = getState(current_state_name: ["state name string", "next states"]).getData().getString()
            //state_name.append(char)
            //getState(current_state_name: ["state name string", "next states"]).getData().setString(value: state_name)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
    
    return false
    
}
func collectLastSpace(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    //j = skipSpaces(input: current_word, i: j)
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char != "\\" && char != " " && char != "/")
    {
        var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
        state_name.append(" ")
        //state_name.append(char)
        parser.getVariable(state_name: ["state name string", "next states"]).setString(value: state_name)
        //getState(current_state_name: ["j"]).getData().setInt(value: j + 1)
        return true
    }
    return false
    
}
func forwardSlash0(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var j = parser.getVariable(state_name: ["j"]).getInt()
    
    // in case there are extra spaces
    j = skipSpaces(input: current_word, i: j)
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char == "/")
    {
        //var state_name = getState(current_state_name: ["state name string", "next states"]).getData().getString()
        //state_name.append(char)
        //let state_sub_name_i = getState(current_state_name: ["state name string", "next states"]).getData().getString()
        //getState(current_state_name: ["names", "next state links"]).getData().appendString(value: state_sub_name_i)
        //getState(current_state_name: ["j"]).getData().setInt(value: j + 1)

        return true
    }
    return false
    
}
func inputHasBeenReadIn0(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    //print("state saved")
    //print(getState(current_state_name: ["state name string", "next states"]).getData().getString())

    return j >= current_word.count
}

func forwardSlash(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    
    // in case there are extra spaces
    //j = skipSpaces(input: current_word, i: j)
    if(j < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
        if(char == "/")
        {
            //var state_name = getState(current_state_name: ["state name string", "next states"]).getData().getString()
            //state_name.append(char)
            //let state_sub_name_i = getState(current_state_name: ["state name string", "next states"]).getData().getString()
            //getState(current_state_name: ["names", "next state links"]).getData().appendString(value: state_sub_name_i)
            parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

            return true
        }
    }
   
    return false
}

func whiteSpace1(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    //j = skipSpaces(input: current_word, i: j)
    
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(j))]
    if(char == " ")
    {
        var state_name = parser.getVariable(state_name: ["state name string", "next states"]).getString()
        //state_name.append(char)
        // should be ["names", "next state link"]
        parser.getVariable(state_name: ["names", "next state links"]).appendString(value: state_name)
        //print(getState(current_state_name: ["names", "next state links"]).getData().getStringList())
        parser.getVariable(state_name: ["j"]).setInt(value: j + 1)

        return true
    }
    return false
}
func inputHasBeenReadIn2(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let j = parser.getVariable(state_name: ["j"]).getInt()
    if(j >= current_word.count)
    {
        let next_state_links = parser.getVariable(state_name: ["names", "next state links"]).getStringList()
        let state_sub_name_i = parser.getVariable(state_name: ["state name string", "next states"]).getString()
        parser.getVariable(state_name: ["names", "next state links"]).appendString(value: state_sub_name_i)
        return true


    }
    return false
}
func addLinkToState(current_state_name: [String], parser: inout Parser) -> Bool
{
    let link = parser.getVariable(state_name: ["names", "next state links"]).getStringList()
    //print(link)
    //print()
    //let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    //print(getState(current_state_name: ["current_word"]).getData().getString())
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()
    //print("level id")
    //print(current_level)

    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    //print("state id")
    //print(current_state)
    
    let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: current_level,
                                                                                                                         s: current_state))
    
    state.appendNextChild(next_child: link)
    //state.Print(indent_level: 1)

    //state.getData().appendString(value: current_word)
    
    //getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state)).Print(indent_level: 1)
    return true
}

func isLetter(char: Character) -> Bool
{
    return char >= "a" && char <= "z" || char >= "A" && char <= "Z"
}
func isLetterUnderscoreNumber(char: Character) -> Bool
{
    //print(char)
    return isLetter(char: char)         ||
            char == "_"                 ||
            char >= "0" && char <= "9"
}
func initK(current_state_name: [String], parser: inout Parser) -> Bool
{
    parser.getVariable(state_name: ["k"]).setInt(value: 0)
    parser.getVariable(state_name: ["function name"]).setString(value: String())

    return true
}
func isFirstCharS(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    //print(current_word)
    //let k = 0//getState(current_state_name: ["k"]).getData().getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    //if(k < current_word.count)
    //{
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(0))]
    //print(char)
    if(char == "S")
    {
        parser.getVariable(state_name: ["k"]).setInt(value: 1)
        return true

    }
    
    
    //}
    return false
}
func letter(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    //print(current_word)
    let k = parser.getVariable(state_name: ["k"]).getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    if(k < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        //print(char)
        if(isLetter(char: char))
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func letterUnderscoreNumber(current_state_name: [String], parser: inout Parser) -> Bool
{
    
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    if(k < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        //print(char)
        if(isLetterUnderscoreNumber(char: char))
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func leftParens(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    if(k < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        
        if(char == "(")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func colon(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    if(k < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        //print(char)
        if(char == ":")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func rightParens(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    //let spaces = collectSpaces(input: current_word, i: j)
    if(k < current_word.count)
    {
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        //print(char)
        if(char == ")")
        {
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true

        }
        
        
    }
    return false
}
func collectLetter(current_state_name: [String], parser: inout Parser) -> Bool
{
    // this function is run after runs so there should be at least one space after the word "runs" in the input
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var k = parser.getVariable(state_name: ["k"]).getInt()
    k = skipSpaces(input: current_word, i: k)
    let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
    //print(char)
    if(isLetter(char: char))
    {
        var state_name = parser.getVariable(state_name: ["function name"]).getString()
        //state_name.append(" ")
        state_name.append(char)
        
        parser.getVariable(state_name: ["function name"]).setString(value: state_name)
        parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
        return true
    }
    return false
}
func collectLetterUnderscoreNumber(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    if(k < current_word.count)
    {
        //j = skipSpaces(input: current_word, i: j)
        let char = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        if(isLetterUnderscoreNumber(char: char))
        {
            var state_name = parser.getVariable(state_name: ["function name"]).getString()
            //state_name.append(" ")
            state_name.append(char)
            
            parser.getVariable(state_name: ["function name"]).setString(value: state_name)
            parser.getVariable(state_name: ["k"]).setInt(value: k + 1)
            return true
        }
    }
    
    return false
}
func inputEmpty(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    let k = parser.getVariable(state_name: ["k"]).getInt()
    if(k >= current_word.count)
    {
        //let next_state_links = getState(current_state_name: ["names", "next state links"]).getData().getStringList()
        //let state_sub_name_i = getState(current_state_name: ["state name string", "next states"]).getData().getString()
        //getState(current_state_name: ["names", "next state links"]).getData().appendString(value: state_sub_name_i)
        return true


    }
    return false
}
func runs(current_state_name: [String], parser: inout Parser) -> Bool
{
    let current_word = parser.getVariable(state_name: ["current_word"]).getString()
    var k = parser.getVariable(state_name: ["k"]).getInt()
    k = skipSpaces(input: current_word, i: k)
    if(k + 3 < current_word.count)
    {
        let char1 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k))]
        let char2 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 1))]
        let char3 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 2))]
        let char4 = current_word[current_word.index(current_word.startIndex, offsetBy: String.IndexDistance(k + 3))]

        if(char1 == "r" &&
           char2 == "u" &&
           char3 == "n" &&
           char4 == "s")
        {
            var state_name = parser.getVariable(state_name: ["function name"]).getString()
            //state_name.append(" ")
            //state_name.append(char1)
            //state_name.append(char2)
            //state_name.append(char3)
            //state_name.append(char4)
            
            parser.getVariable(state_name: ["function name"]).setString(value: state_name)
            parser.getVariable(state_name: ["k"]).setInt(value: k + 4)
            return true
        }
    }
    return false

}
func saveFunctionName(current_state_name: [String], parser: inout Parser) -> Bool
{
    // save current word as function name
    //print("saveFunctionName")
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    let current_word = parser.getVariable(state_name: ["function name"]).getString()
    print(current_word)
    let current_level = parser.getVariable(state_name: ["level_number", String(max_stack_index)]).getInt()
    //print("level id")
    //print(current_level)

    let current_state = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    //print("state id")
    //print(current_state)
    
    let state = parser.getVariable(state_name: ["sparse_matrix"]).getContextStateFromPointToContextState(key: Point.init(l: current_level,
                                                                                                                         s: current_state))
    state.setFunctionName(function_name: current_word)
    //getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state)).Print(indent_level: 1)
    
    return true
}
func isCurrentWordASiblingOfPrevWord(current_state_name: [String], parser: inout Parser) -> Bool
{
    return parser.getVariable(state_name: ["sibling"]).getBool()

}

func isCurrentWordADifferentParentOfPrevWord(current_state_name: [String], parser: inout Parser) -> Bool
{
    print("new parent")
    //, getState(current_state_name: ["new_parent"]).getData().getBool())
    return parser.getVariable(state_name: ["new_parent"]).getBool()
}
func windBackStateNameFromEnd(current_state_name: [String], parser: inout Parser) -> Bool
{
    let prev_prev_indent = parser.getVariable(state_name: ["prev_prev_indent"]).getInt()
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let current_indent = parser.getVariable(state_name: ["next_indent"]).getInt()
    var last_state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    
    // very not intuitive, because the incrementing numbers and strings are set up in a certain way
    // the second +1 is so the value is positive cause saveNewState deletes the last item off(throwing off this equation cause
    // we are assuming no state name parts are deleted off after the dead state is saved)
    let names_to_delete_from_the_end = prev_prev_indent - prev_indent  + 1
    // 7 and 6
    // 2
    // len(state name) = 3
    // total items to add from indent count of 5
    // [0, len(state name) -2) = [0, 1) range of how many items to copy from the last state name(by ignoring the name parts that are supposed to be deleted)
    print( parser.getVariable(state_name: ["prev_word"]).getString(), parser.getVariable(state_name: ["current_word"]).getString())
    
    print(prev_prev_indent, prev_indent, current_indent)
    var cleaned_state_name = [String]()
    print(0, last_state_name.count - names_to_delete_from_the_end)
    print(last_state_name)
    for i in (0..<(last_state_name.count - names_to_delete_from_the_end))
    {
        cleaned_state_name.append(last_state_name[i])
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: cleaned_state_name)
    print(parser.getVariable(state_name: ["name", "state_name"]).getStringList())
    return true
}
func isAStateName(current_state_name: [String], parser: inout Parser) -> Bool
{
    print(parser.getVariable(state_name: ["current_word"]).getString())
    return !(parser.getVariable(state_name: ["current_word"]).getString() == "Children" ||
             parser.getVariable(state_name: ["current_word"]).getString() == "Next"     ||
             parser.getVariable(state_name: ["current_word"]).getString() == "Function")
}
func isCurrentIndentSameAsIndentForLevel(current_state_name: [String], parser: inout Parser) -> Bool
{
    // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let current_level_indent_number = parser.getVariable(state_name: ["indent_number", String(max_stack_index)]).getInt()
    print(prev_indent, current_level_indent_number)
    return prev_indent == current_level_indent_number
}
func deleteCurrentStateName(current_state_name: [String], parser: inout Parser) -> Bool
{
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: [])
    return true
}
func isCurrentIndentGreaterThanAsIndentForLevel(current_state_name: [String], parser: inout Parser) -> Bool
{
    // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
    let prev_indent = parser.getVariable(state_name: ["prev_indent"]).getInt()
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    
    let current_level_indent_number = parser.getVariable(state_name: ["indent_number", String(max_stack_index)]).getInt()
    print(prev_indent, current_level_indent_number)
    return prev_indent > current_level_indent_number
}
func deleteTheLastContext(current_state_name: [String], parser: inout Parser) -> Bool
{
    var state_name = parser.getVariable(state_name: ["name", "state_name"]).getStringList()
    //print(state_name)

    let x = state_name.dropLast()
    var new_state_name = [String]()
    for i in x
    {
        new_state_name.append(i)
    }
    parser.getVariable(state_name: ["name", "state_name"]).setStringList(value: new_state_name)
    //print(state_name)
    //print(new_state_name)
    return true
}

func incrementTheStateId(current_state_name: [String], parser: inout Parser) -> Bool
{
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    let current_level_state_number = parser.getVariable(state_name: ["state_number", String(max_stack_index)]).getInt()
    //let current_state = parser.getVariable(state_name: ["state_id"]).getInt()
    
    parser.getVariable(state_name: ["state_number", String(max_stack_index)]).setInt(value: current_level_state_number + 1)
    //parser.getVariable(state_name: ["state_id"]).setInt(value: current_state + 1)
    
    //print(max_stack_index, getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt(), getState(current_state_name: ["state_id"]).getData().getInt())
    return true
}
func decreaseMaxStackIndex(current_state_name: [String], parser: inout Parser) -> Bool
{
    let max_stack_index = parser.getVariable(state_name: ["max_stack_index"]).getInt()
    parser.getVariable(state_name: ["max_stack_index"]).setInt(value: max_stack_index - 1)
    let current_index = parser.getVariable(state_name: ["indent_number", String(max_stack_index - 1)]).getInt()
    print("decreased indent level")
    print(current_index)
    return true
    
}
func readFile(file: String) -> String
{

    //let file = "input" //this is the file. we will write to and read from it

    //let text = "some text" //just a text
    var text2: String = String()
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(file)

        //writing
       // do {
       //     try text.write(to: fileURL, atomically: false, encoding: .utf8)
       // }
        //catch {/* error handling here */}

        //reading
        do {
            text2 = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {
        print("can't read file")
        /* error handling here */
        
        }
    }
    return text2
}
/*
class
    table
    f(name: ).get()
        g(name:, table:).getData()
    f(name: ).set()
        g(name:, table:).getData()

*/


/*
         // level_indent_stack
                // 0, 1, 2
                // level_number
                    // 0, 1, 2
                // state_number
                    // 0, 1, 2
                // indent_number
                    // 0, 1, 2
 
        */

                      /*
 
        Loops:
            name 0, advance loop, (is_children, is_next)
 
                is_children, save new state | from before children, advance | past children, advance level, name 0
 
                is_next, save new state | from before next, advance | to next state link, save | next state link, advance | to maybe next state link,
                (1: is current word a sibling of prev word, 2: advance past | Function),
                    there is either 1 next state and a function or multiple next states and a function
                    from 2: save function name, advance again,
                is current word a different parent of prev word, is current word a state name, is current indent == indent for level,
                increment state_id for the current level, name 0
                    from 1: save | next state link, advance | to maybe next state link (1, 2)
            is_dead_state, save dead state, name 0
 
        I define easily changed to mean that the change doesn't result in headaches over how the represention of a solution makes certain changes easier and others harder(changing a CFG for example)
        why this is really hard
        here is what must be read in to make a single state
        all the substates
        all the different amounts of indents for the strings in the state's name
        an atribute(Next, Children) is only present when there is a state name inside the attribute
        must account for all the variations of what attributes are present and which ones are not(the sequence of atributes and state names for a single state are varied )
        when traversing the printout(in the form of a tree), you must keep track of each level you have visited for depth first traversal.
        also, you must do breath first traversal to match up the attributes with the correct state.  Because of substates, the last attribute for the first state could be at the very end of the file.  This also requires saving parts of each state.
 
        the interpretoer must be easily changed to account for new things
        I chose to use my Hierarchial Context Sensitive State Machine API instead of CFG and CSG for the following reasons:
        It's hard to make a language with a contest free grammer.  It's easy to make an infinite recursive tree, making an unambiguous CFG is harder to make, and fixing errors may require reformulating the entire grammer.  I don't want to make a grammer that has the slightest possibility of being very brittle for this project.  This project must be easily adaptable.
        A context sensitive grammer would fit, but requires many rules to implement a language as simple as {a^nb^nc^n | n > 0}
 
        the grammers are hard to relate to from a human perspective.  My state machine is based off of the idea of context sensitivity for all sequences and all levels of the hierarchy(Inspired by Numenta's research).  I find that easier to relate to.
 

        This is still really hard with my state machine, but that is because the problem itself is really hard.  I don't want to add the difficulty of a grammer to this.
 
 
        Because using a finite state machine started becoming really messy, using the state machine system I made from python and javascript looked like a much more reasonable alternative, considering the conditions I have set for this project above.
        */
