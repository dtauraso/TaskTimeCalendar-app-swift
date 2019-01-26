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
    func getContextStateFromStringListToContextStateEntry(key: [String]) -> ContextState
    {
        let entry = self.name_state_table[key]
        if(entry != nil)
        {
            return entry!
        }
        return ContextState.init(name: [], function: returnTrue)
    }
    func setState(current_state: ContextState)
    {
        name_state_table[current_state.getName()] = current_state
 
    }
    //            getState(current_state_name: ["i"]).getData().setInt(value: -1)

    func getState(current_state_name: [String]) -> ContextState
    {
        if(name_state_table[current_state_name] != nil)
        {
            return name_state_table[current_state_name]!

        }
        print("no state by ", current_state_name, "is in name_state_table")
        //exit(0)
        return ContextState.init(name: ["state does not exist"], function: returnTrue(current_state_name: ))
    }
    func setData(current_state_name: [String], data: Int)
    {
        if(name_state_table[current_state_name] != nil)
        {
            
            name_state_table[current_state_name]?.getData().setInt(value: data)
        }
    }
    func returnTrue(current_state_name: [String]) -> Bool
    {
        return true
    }
    func returnFalse(current_state_name: [String]) -> Bool
    {
        return false
    }
    
    func advanceInit(current_state_name: [String]) -> Bool
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
        var i: Int = getState(current_state_name: ["i"]).getData().getInt()
        let input: String = getState(current_state_name: ["input"]).getData().getString()
        var index = input.index(input.startIndex, offsetBy: 0)
    
        print(input)
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
        //print(input[index])
        i = index.encodedOffset
        //setData(current_state_name: ["i"], data: i)
        getState(current_state_name: ["i"]).getData().setInt(value: i)
        getState(current_state_name: ["current_word"]).getData().setString(value: word)

        //print(indent_count)
        getState(current_state_name: ["next_indent"]).getData().setInt(value: indent_count)
        //print(getState(current_state_name: ["next_indent"]).getInt())
        //print(word)
        //exit(0)
        
        return true
    }
    func collectName(current_state_name: [String]) -> Bool
    {
        print("collectName")
        //print(getState(current_state_name: ["current_word"]).getString())
        let state_name_progress = getState(current_state_name: ["current_word"]).getData().getString()
        print(state_name_progress)
        //print( getState(current_state_name: ["name", "state_name"]).getStringList())
        getState(current_state_name: ["name", "state_name"]).getData().appendString(value: state_name_progress)
        //print(getState(current_state_name: ["name", "state_name"]).getStringList())
        //exit(0)
        return true
    }
    func advanceLoop(current_state_name: [String]) -> Bool
    {
        // i is pointing to the
        print("in advanceLoop")
        var i: Int = getState(current_state_name: ["i"]).getData().getInt()
        let input: String = getState(current_state_name: ["input"]).getData().getString()
        var next_indent = getState(current_state_name: ["next_indent"]).getData().getInt()
        var prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        var current_word = getState(current_state_name: ["current_word"]).getData().getString()
        var prev_word = getState(current_state_name: ["prev_word"]).getData().getString()
        var index = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
        // input[index] is not supposed to = '\n'
        if(index.encodedOffset < input.count)
        {
            print("|", input[index], "|")

        }
        else
        {
            return false
        }
        print(prev_indent, next_indent)
        var word: String = String()
        
        while(index.encodedOffset < input.count && input[index] != "\n")
        {
            if(index.encodedOffset >= input.count)
            {
                return false
            }
            word.append(input[index])
            index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
        }
        
        print(index.encodedOffset)
        print(word)
        
        // end of file so save the function name
        if(index.encodedOffset + 1 >= input.count)
        {
            getState(current_state_name: ["i"]).getData().setInt(value: -1)
            //print(word)
            getState(current_state_name: ["current_word"]).getData().setString(value: word)

            saveFunctionName(current_state_name: current_state_name)
            return false
        }
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
        print(index.encodedOffset)
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
        print(index.encodedOffset)
        // setup what_is_current_word_to_pre_word member variables
        getState(current_state_name: ["child"]).getData().setBool(value: false)
        getState(current_state_name: ["sibling"]).getData().setBool(value: false)
        getState(current_state_name: ["new_parent"]).getData().setBool(value: false)

        if(prev_indent < next_indent)
        {
            getState(current_state_name: ["child"]).getData().setBool(value: true)
        }
        else if(prev_indent == next_indent)
        {
            getState(current_state_name: ["sibling"]).getData().setBool(value: true)
        }
        else if(prev_indent > next_indent)
        {
            getState(current_state_name:["new_parent"]).getData().setBool(value: true)
            //print(true)
        }
        print(prev_indent, next_indent)
        swap(&next_indent, &prev_indent)
        swap(&current_word, &prev_word)
        current_word = word
        print("prev word, current word")
        print(prev_word, current_word)
        print(indent_count)
        next_indent = indent_count
        print("i", i)

        i = index.encodedOffset
        
        //print(i)
        //print(prev_indent, next_indent)
        //setData(current_state_name: ["i"], data: i)
        getState(current_state_name: ["i"]).getData().setInt(value: i)
        getState(current_state_name: ["prev_word"]).getData().setString(value: prev_word)

        getState(current_state_name: ["current_word"]).getData().setString(value: current_word)
        getState(current_state_name: ["prev_indent"]).getData().setInt(value: prev_indent)

        getState(current_state_name: ["next_indent"]).getData().setInt(value: next_indent)

        //print(getState(current_state_name: ["i"]).getData().getInt())
        //print(getState(current_state_name: ["prev_word"]).getData().getString(), getState(current_state_name: ["current_word"]).getData().getString())
        
        //print(getState(current_state_name: ["prev_indent"]).getData().getInt(), getState(current_state_name: ["next_indent"]).getData().getInt())
        if(index.encodedOffset < input.count)
        {
            print("|", input[index], "|")

        }
        print("current stack")
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        for i in (0...max_stack_index)
        {
            print("level, state")
            print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
            
            print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
            print()
        }
        //exit(0)
        return true
    }
    func isDeadState(current_state_name: [String]) -> Bool
    {
        print("is in dead state")
        let next_indent = getState(current_state_name: ["next_indent"]).getData().getInt()
        let prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        print(next_indent == prev_indent)
        let current_word = getState(current_state_name: ["current_word"]).getData().getString()
        let prev_word = getState(current_state_name: ["prev_word"]).getData().getString()
        print("prev word, current word")
        print(prev_word, current_word)
        return next_indent == prev_indent
    }
    func isChildren(current_state_name: [String]) -> Bool
    {
        return getState(current_state_name: ["current_word"]).getData().getString() == "Children"

    }
    func isNext(current_state_name: [String]) -> Bool
    {
        return getState(current_state_name: ["current_word"]).getData().getString() == "Next"

    }
    func isCurrentWordFunction(current_state_name: [String]) -> Bool
    {
            return getState(current_state_name: ["current_word"]).getData().getString() == "Function"

    }
    func saveNewState(current_state_name: [String]) -> Bool
    {
        print("saveNewState")
        // if at any other state, have to set it's parent to the last state saved and the last state saved's first children
        // if there is more than 1 child, do the above for the first child only
        
        // does not work for more than 1 parent
        var collected_state_name = getState(current_state_name: ["name", "state_name"]).getData().getStringList()
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
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        
        let level = getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt()
        print(level)
        let state = getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt()
        // level_id and state_id are the top of the stack
        // the stack should have the current level, current indent level for state, ith state
        print(state)
        //print(getState(current_state_name: ["child"]).getData().getBool())

        let new_state = ContextState.init(name: collected_state_name2, function: returnTrue(current_state_name:))
        if(current_state_name == ["save dead state"])
        {
            new_state.setFunctionName(function_name: "returnTrue")
        }
        // point_table "[[String]: Point]"
        getState(current_state_name: ["point_table"]).getData().setStringListToPointEntry(key: collected_state_name2,
                                                                                          value: Point.init(l: level, s: state))

        
        // sparse_matrix "[Point: ContextState]"
        getState(current_state_name: ["sparse_matrix"]).getData().setPointToContextState(key: Point.init(l: level, s: state),
                                                                                         value: new_state)
        
        
        if(level == 0 && state == 0)
        {
                // if at first state(0, 0), have to set it's parent and root's start children
                //print("here", collected_state_name)
                let point: Point = Point.init(l: 0, s: 0)

            let state = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: point)
                //print("origin state", state.getName())
                state.setParents(parents: [["root"]])
                //state.Print(indent_level: 0)

                //exit(0)
            

        }
        // for when same level is reentered later in the tree
        else// if (state >= 0)
        {
            
            
            let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
            let prev_level_state_number = getState(current_state_name: ["state_number", String(max_stack_index - 1)]).getData().getInt()
            
            let prev_level_level_number = getState(current_state_name: ["level_number", String(max_stack_index - 1)]).getData().getInt()
            print("prev level things")
            print(prev_level_level_number, prev_level_state_number)
            let point: Point = Point.init(l: prev_level_level_number, s: prev_level_state_number)
            
            let parent_state: ContextState = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: point)
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
            parent_state.Print(indent_level: 0)

            //print("child location", level, state)
            //print()
            let location_of_child = Point.init(l: level, s: state)
            let child_state: ContextState = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: location_of_child)
            //print(child_state.getName())
            child_state.setParents(parents: [parent_state.getName()])


            //var current_state = getState(current_state_name: ["state_id"]).getData().getInt()
            
            //getState(current_state_name: ["state_number", String(max_stack_index)]).getData().setInt(value: current_level_state_number + 1)
            //getState(current_state_name: ["state_id"]).getData().setInt(value: current_state + 1)
            
            print(max_stack_index, prev_level_state_number, prev_level_level_number)

            
            // can't assume the state in the higher level is the same as this one
            // the second to top item in the stack is the state value for the higher level
        }
        
        
        
        // print saved state
        let point = getState(current_state_name: ["point_table"]).getData().getPointFromStringListToPointEntry(key: collected_state_name)
        print("point")
        point.Print()

        let context_state = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: point)
        
        context_state.Print(indent_level: level)
        print()
 
        //getState(current_state_name: ["name", "state_name"]).getData().setStringList(value: [])
        var state_name = getState(current_state_name: ["name", "state_name"]).getData().getStringList()
        let x = state_name.dropLast()
        var new_state_name = [String]()
        for i in x
        {
            new_state_name.append(i)
        }
        getState(current_state_name: ["name", "state_name"]).getData().setStringList(value: new_state_name)
        return true
    }
    func advanceLevel(current_state_name: [String]) -> Bool
    {
        print("advance level")

        
        // take the current level and state values from the tracker and use them to calculate secondary name for stack variables, location of stack veriables in the levels matrix
        // does depth first traversal using the level id's
        // does breath first traversal using the state id's
        var max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        
        print("current stack")
        for i in (0...max_stack_index)
        {
            print("level, state")
            print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
            
            print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
            print()
        }
        
        print(getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt())
        let current_level = getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt()
        print("level_number")
        print(getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt())
        
        print("state level_number")
        print(getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt())
        let current_state = getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt()

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
        let prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        
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
        let state: ContextState =  self.getContextStateFromStringListToContextStateEntry(key: ["state_number", String(max_stack_index + 1)])
        print("push to stack: current_level, current_state, current_indent max_stack_index")
        print(current_level, current_state, prev_indent, String(max_stack_index))
        // push
        if(state == ContextState.init(name: [], function: returnTrue))
        {
            max_stack_index += 1
            //let level_number_point: Point = Point.init(l: 0, s: level_number_i_state_id + 3)
            self.name_state_table[["level_number", String(max_stack_index)]] = ContextState.init(name: ["level_number", String(max_stack_index)],
                                                                                                 nexts: [],
                                                                                                 start_children: [],
                                                                                                 function: returnTrue(current_state_name:),
                                                                                                 function_name: "returnTrue",
                                                                                                 data: Data.init(new_data: ["Int": current_level + 1]),
                                                                                                 parents: [])
            //self.name_state_table[(self.levels[level_number_point]?.getName())!] = level_number_point

            //let state_number_point: Point = Point.init(l: 0, s: state_number_i_state_id + 3 )
            self.name_state_table[["state_number", String(max_stack_index)]] = ContextState.init(name: ["state_number", String(max_stack_index)],
                                                                                                 nexts: [],
                                                                                                 start_children: [],
                                                                                                 function: returnTrue(current_state_name:),
                                                                                                 function_name: "returnTrue",
                                                                                                 data: Data.init(new_data: ["Int": 0]),
                                                                                                 parents: [])
            //self.name_state_table[(self.levels[state_number_point]?.getName())!] = state_number_point

            //let indent_number_point: Point = Point.init(l: 0, s: indent_number_i_state_id + 3)
            self.name_state_table[["indent_number", String(max_stack_index)]] = ContextState.init(name: ["indent_number", String(max_stack_index)],
                                                                                                  nexts: [],
                                                                                                  start_children: [],
                                                                                                  function: returnTrue(current_state_name:),
                                                                                                  function_name: "returnTrue",
                                                                                                  data: Data.init(new_data: ["Int": prev_indent]),
                                                                                                  parents: [])
            //self.name_state_table[(self.levels[indent_number_point]?.getName())!] = indent_number_point
            
            // going down
            //getState(current_state_name: ["level_id"]).getData().setInt(value: current_level + 1)

            getState(current_state_name: ["max_stack_index"]).getData().setInt(value: max_stack_index)
            print("pushed stack")
            for i in (0...max_stack_index)
            {
                print("level, state")
                print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
                
                print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
                print()
            }

        }
        // copy over
        else
        {
            //var hidden_stack_item: ContextState = self.na[point]!
            //let nth_level_pth_state = hidden_stack_item.getData().getInt()
            //hidden_stack_item.getData().setInt(value: nth_level_pth_state + 1)
            getState(current_state_name: ["max_stack_index"]).getData().setInt(value: max_stack_index + 1)
            let last_value = getState(current_state_name: ["state_number", String(max_stack_index + 1)]).getData().getInt()
            
            // increment state_number[max_stack_index + 1]
            getState(current_state_name: ["state_number", String(max_stack_index + 1)]).getData().setInt(value: last_value + 1)

            max_stack_index += 1
            print("copied stack")
            for i in (0...max_stack_index)
            {
                print("level, state")
                print(getState(current_state_name: ["level_number", String(i)]).getData().getInt())
                
                print(getState(current_state_name: ["state_number", String(i)]).getData().getInt())
                print()
            }

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
    
    func saveNextStateLink(current_state_name: [String]) -> Bool
    {
        
        //var next_state_links = getState(current_state_name: current_state_name).getData().getStringList()
        //print(next_state_links)
        
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
        return true
    }
    func charNotBackSlashNotWhiteSpace(current_state_name: [String]) -> Bool
    {
            let current_word = getState(current_state_name: ["current_word"]).getData().getString()

    }
    func backSlash(current_state_name: [String]) -> Bool
    {
            let current_word = getState(current_state_name: ["current_word"]).getData().getString()

    }
    func whiteSpace(current_state_name: [String]) -> Bool
    {
           let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    }
    func collectLastSpace(current_state_name: [String]) -> Bool
    {
           let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    }
    func forwardSlash(current_state_name: [String]) -> Bool
    {
           let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    }
    func inputHasBeenReadIn(current_state_name: [String]) -> Bool
    {
           let current_word = getState(current_state_name: ["current_word"]).getData().getString()
    }
    func isCurrentWordASiblingOfPrevWord(current_state_name: [String]) -> Bool
    {
        //print(getState(current_state_name: ["sibling"]).getData().getBool())
        return getState(current_state_name: ["sibling"]).getData().getBool()

    }
    func saveFunctionName(current_state_name: [String]) -> Bool
    {
        // save current word as function name
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        let current_word = getState(current_state_name: ["current_word"]).getData().getString()
        let current_level = getState(current_state_name: ["level_number", String(max_stack_index)]).getData().getInt()
        //print("level id")
        //print(current_level)

        let current_state = getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt()
        //print("state id")
        //print(current_state)
        
        let state = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state))
        state.setFunctionName(function_name: current_word)
        getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: Point.init(l: current_level, s: current_state)).Print(indent_level: 1)

        return true
    }
    func isCurrentwordADifferentParentOfPrevWord(current_state_name: [String]) -> Bool
    {
        //print("new parent", getState(current_state_name: ["new_parent"]).getData().getBool())
        return getState(current_state_name: ["new_parent"]).getData().getBool()
    }
    func isAStateName(current_state_name: [String]) -> Bool
    {
        return !(getState(current_state_name: ["current_word"]).getData().getString() == "Children" ||
                 getState(current_state_name: ["current_word"]).getData().getString() == "Next"     ||
                 getState(current_state_name: ["current_word"]).getData().getString() == "Function")
    }
    func isCurrentIndentSameAsIndentForLevel(current_state_name: [String]) -> Bool
    {
        // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
        let prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        
        let current_level_indent_number = getState(current_state_name: ["indent_number", String(max_stack_index)]).getData().getInt()
        print(prev_indent, current_level_indent_number)
        return prev_indent == current_level_indent_number
    }
    func deleteCurrentStateName(current_state_name: [String]) -> Bool
    {
        getState(current_state_name: ["name", "state_name"]).getData().setStringList(value: [])
        return true
    }
    func isCurrentIndentGreaterThanAsIndentForLevel(current_state_name: [String]) -> Bool
    {
        // already incremented to the state name, so the next indent is pointing to the Children word(the next indent is past the current word of consideration)
        let prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        
        let current_level_indent_number = getState(current_state_name: ["indent_number", String(max_stack_index)]).getData().getInt()
        print(prev_indent, current_level_indent_number)
        return prev_indent > current_level_indent_number
    }
    func deleteTheLastContext(current_state_name: [String]) -> Bool
    {
        var state_name = getState(current_state_name: ["name", "state_name"]).getData().getStringList()
        //print(state_name)

        let x = state_name.dropLast()
        var new_state_name = [String]()
        for i in x
        {
            new_state_name.append(i)
        }
        getState(current_state_name: ["name", "state_name"]).getData().setStringList(value: new_state_name)
        //print(state_name)
        //print(new_state_name)
        return true
    }
    
    func incrementTheStateId(current_state_name: [String]) -> Bool
    {
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        let current_level_state_number = getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt()
        let current_state = getState(current_state_name: ["state_id"]).getData().getInt()
        
        getState(current_state_name: ["state_number", String(max_stack_index)]).getData().setInt(value: current_level_state_number + 1)
        getState(current_state_name: ["state_id"]).getData().setInt(value: current_state + 1)
        
        print(max_stack_index, getState(current_state_name: ["state_number", String(max_stack_index)]).getData().getInt(), getState(current_state_name: ["state_id"]).getData().getInt())
        return true
    }
    func decreaseMaxStackIndex(current_state_name: [String]) -> Bool
    {
        let max_stack_index = getState(current_state_name: ["max_stack_index"]).getData().getInt()
        getState(current_state_name: ["max_stack_index"]).getData().setInt(value: max_stack_index - 1)
        return true
        
    }
    func testing(current_state_name: [String]) -> Bool
    {
        let test: String = self.name_state_table[current_state_name]!.getData().getString()
        print(test)
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
    init()
    {
        // this contexual state chart is a deterministic machine
        // this process hasn't been tested on bad input
        // bad input will be tested later
        // current bugs for next version
        /*
            saveNewState does not work for more than 1 parent
            [Next, Function] should come before Children(top down flow)
         
        */
        // version 1:
        // currently unimplimented:
        /*
        dead state
        dead states(next test case)
        test 0
                                        Function
                                checkMark
                        end
                        ab
                        timer
                            Next
        test 1
                                        Function
                                checkMark
                        end
                        ab
                            1
                                1
                            2
                        timer
                            Next
        test 1.2
                                        Function
                                checkMark
                        end
                        a1
                        ab
                            1
                                1
                            2
                        timer
                            Next
         
         test 2
                                    Function
                                checkMark
                        ab
                            1
                                1
                            2
                        timer
                            Next
        test 2.1
                                    Function
                                checkMark
                        ab
                            1
                                1
                            2
                                1
                        timer
                            Next
        function_name to Function retracing from stack
        function_name to next state name copy on current level of stack
        more than 1 string for a state name
        
        make diagram in curio
        savestate needs to handle state links as an option instead of a state name
        will need more levels for saving the state and the dead states and the function names
        
        

        */
        self.name_state_table[["states", "state"]] = ContextState.init(name: ["states", "state"],
                                                               nexts: [],
                                                               start_children:[["names", "0"]],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [["root", "0"]])
    
        // variables
        ////////
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
        */
        ///delete
        //////////
        self.name_state_table[["level_id"]] = ContextState.init(name: ["level_id"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [] )
    
        self.name_state_table[["state_id"]] = ContextState.init(name: ["state_id"],
                                                               nexts: [],
                                                               start_children: [],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: ["Int": 0]),
                                                               parents: [])
        ///////////
        
        self.name_state_table[["prev_indent"]] = ContextState.init(name: ["prev_indent"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
    
    
        self.name_state_table[["prev_word"]] = ContextState.init(name: ["prev_word"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": "root"]),
                                                           parents: [])
    
    
        self.name_state_table[["current_word"]] = ContextState.init(name: ["current_word"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": ""]),
                                                           parents: [])

        self.name_state_table[["next_indent"]] = ContextState.init(name: ["next_indent"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])


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

        self.name_state_table[["level_indent_stack"]] = ContextState.init(name: ["level_indent_stack"],
                                                           nexts: [],
                                                           start_children: [["level_number", "0"],
                                                                            ["state_number", "0"],
                                                                            ["indent_number", "0"],
                                                                            ["max_stack_index"]],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])

        self.name_state_table[["level_number", "0"]] = ContextState.init(name: ["level_number", "0"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        
        self.name_state_table[["state_number", "0"]] = ContextState.init(name: ["state_number", "0"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        


        
        self.name_state_table[["indent_number", "0"]] = ContextState.init(name: ["indent_number", "0"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        
        self.name_state_table[["max_stack_index"]] = ContextState.init(name: ["max_stack_index"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
 

        
        /*
            prev_indent, prev_word, current_word, next_indent, what_is_current_word_to_prev_word
                                                                    child, sibling, parent
        */
        // (0, 10),  i
        
        
        // variables
        //////

        self.name_state_table[["i"]] = ContextState.init(name: ["i"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])


        self.name_state_table[["what_is_current_word_to_pre_word"]] = ContextState.init(name: ["what_is_current_word_to_pre_word"],
                                                           nexts: [],
                                                           start_children: [["child"], ["sibling"], ["new_parent"]],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
        
            // child
                self.name_state_table[["child"]] = ContextState.init(name: ["child"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])

            // sibling
                self.name_state_table[["sibling"]] = ContextState.init(name: ["sibling"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])

            // parent
                self.name_state_table[["new_parent"]] = ContextState.init(name: ["new_parent"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
        ///////
        
        self.name_state_table[["advance", "init"]] = ContextState.init(name: ["advance", "init"],
                                                           nexts: [["name", "0"]],
                                                           start_children: [],
                                                           function: advanceInit(current_state_name:),
                                                           function_name: "advanceInit",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [["names", "0"]])

        // advance
            // advance states
                // have the child, sibling, parent states
                // have a ssubmachine called advance that gets the next word and sets all this state variables
        self.name_state_table[["sparse_matrix"]] = ContextState.init(name: ["sparse_matrix"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["[Point: ContextState]": [:]]),
                                                           parents: [])
    
        
    
        self.name_state_table[["input"]] = ContextState.init(name: ["input"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": readFile(file: "input.txt")]),
                                                           parents: [])
        
        self.name_state_table[["point_table"]] = ContextState.init(name: ["point_table"],
                                                           nexts: [],
                                                           start_children: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["[[String]: Point]": [:]]),
                                                           parents: [])

        ///////////
        
        //print("\n\n")
            // "advance to names at 0"
            self.name_state_table[["names", "0"]] = ContextState.init(name: ["names", "0"],
                                                               nexts: [],
                                                               start_children: [["advance", "init"]],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [["states", "state"]])
        
    
            //print("\n\n")
    
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
        
        
        
         
        
        states
            state
                Children
                    names
                        -0
                            Children
                                advance // update point to reflect double incrememnt in level
                                    -init
                                        Next
                                            name 0
                                        Function
                                            advanceInit
                                    loop
                                        Next
                                            is_children,
                                            is_next,
                                            name 0
                                        Function
                                            advanceLoop
                                    past children
                                        Next
                                            advance level
                                        Function
                                            advanceLoop
                                    level
                                        Next
                                            name 0
                                        Function
                                            advanceLevel
                                    to next state link
                                        Next
                                            save | next state link
                                        Function
                                            advanceLoop
                                    to maybe next state link
                                        Next
                                            is current word a sibling of prev word,
                                            advance past | Function
                                        Function
                                            advanceLoop
                                    again
                                        Next
                                            is current word a different parent of prev word
                                        Function
                                            advanceLoop
                                is current word a different parent of prev word
                                    Next
                                        is current word a state name, (is current word "Function")
                                    Function
                                        isCurrentwordADifferentParentOfPrevWord
                                (is current word "Function")
                                    Next
                                        (decrement max_stack_index by 1)
                                    Function
                                        isCurrentWordFunction
         
                                (decrement max_stack_index by 1)
                                    Next
                                        advance past | Function
                                    Function
                                        decrememntMaxStackIndex
                                is current word a state name
                                    Next
                                        is current indent == indent for level
                                    Function
                                         isAStateName
                                 is current indent == indent for level
                                    Next
                                        increment state_id for the current level
                                    Function
                                        isCurrentIndentSameAsIndentForLevel
                                increment state_id for the current level
                                    Next
                                        name 0
                                    Function
                                        incrementTheStateId
                                advance past
                                    Function
                                        Next
                                            save function name
                                    Function
                                        advanceLoop
                                save function name
                                    Next
                                        advance again
                                    Function
                                        advanceLoop
         
                                is current word a sibling of prev word
                                    Next
                                         save | next state link
         
                                name
                                    0
                                        Next
                                            is_dead_state, advance loop
                                        Function
                                            collectName
                                    state_name
                                        Data
                                            []
                                is_children
                                    Next
                                        save new state | from before children
                                    Function
                                        isChildren
                                save new state
                                    from before children
                                        Next
                                            advance | past children
                                        Function
                                            saveNewState
                                    from before next
                                        Next
                                            advance | to next state link
                                        Function
                                            saveNewState
                                save
                                    next state link
                                        Next
                                            advance | to maybe next state link
                                        Function
                                            saveNextStateLink
                                is_next
                                    Next
                                        save new state | from before next
                                is_dead_state
                                    Next
                                        save dead state
                                    Function
                                        isDeadState
                                save dead state
                                    Next
                                        advance to next state
                                    Function
                                        saveNewState
                                advance to next state
                                    Next
                                        name 0
                                    Function
                                        advanceLoop
         
         
         
                            Function
                                returnTrue
         
                Function
                    returnTrue
         
        i
            Data
                0
         
        point_table
            Data
                none
        sparse_matrix
            Data
                none
        
        input
            Data
                the string
        level_id
            Data
                0
        state_id
            Data
                0
        prev_indent
            Data
                0
        prev_word
            Data
                ''
        current_word
            Data
                ''
        next_indent
            Data
                0
        level_indent_stack
            Children
                level_number
                    -0
                        Data
                            0
                state_number
                    -0
                        Data
                            0

                indent_number
                    -0
                        Data
                            0

                -max_stack_index
                        Data
                            0
        i
            Data
                0
        what_is_current_word_to_pre_word
            Children
                -child
                    Data
                        none
                -sibling
                    Data
                        none
                -new_parent
                    Data
                        none
         
        */
                self.name_state_table[["name", "0"]] = ContextState.init(name: ["name", "0"],
                                                                   nexts: [["is_dead_state"], ["advance", "loop"]],
                                                                   start_children: [],
                                                                   function: collectName(current_state_name:),
                                                                   function_name: "collectName",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [["names", "0"]])
        
        
        
                //print("\n\n")
                // "name", "state_name"
                self.name_state_table[["name", "state_name"]] = ContextState.init(name: ["name", "state_name"],
                                                                   nexts: [],
                                                                   start_children: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: ["[String]":[]]),
                                                                   parents: [])

    
                self.name_state_table[["indent_increase", "0"]] = ContextState.init(name: ["indent_increase", "0"],
                                                           nexts: [["name", "0"], ["\"Start Children\"", "0"]],
                                                           start_children: [],
                                                           function: returnFalse(current_state_name:),
                                                           function_name: "returnFalse",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
                //print("\n\n")
    
                self.name_state_table[["indent_increase", "1"]] = ContextState.init(name: ["indent_increase", "1"],
                                                                   nexts: [["states", "substates"]],
                                                                   start_children: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                //print("\n\n")


                // the recursion will be detected by the positive level difference between the current state and the Start Children State
                self.name_state_table[["indent_increase", "2"]] = ContextState.init(name: ["indent_increase", "2"],
                                                                   nexts: [["indent_decrease", "1"]],
                                                                   start_children: [["names", "0"]],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                //print("\n\n")

                self.name_state_table[["\"Start Children\"", "0"]] = ContextState.init(name: ["\"Start Children\"", "0"],
                                                                   nexts: [],
                                                                   start_children: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                // has no neighbors the stack should shrink after this state runs

                //print("\n\n")
    
                self.name_state_table[["indent_decrease", "0"]] = ContextState.init(name: ["indent_decrease", "0"],
                                                                   nexts: [],
                                                                   start_children: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                //print("\n\n")
    
                self.name_state_table[["indent_decrease", "1"]] = ContextState.init(name: ["indent_decrease", "1"],
                                                                   nexts: [],
                                                                   start_children: [],
                                                                   function: returnFalse(current_state_name:),
                                                                   function_name: "returnFalse",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                //print("\n\n")
                self.name_state_table[["is_dead_state"]] = ContextState.init(name: ["is_dead_state"],
                                                                   nexts: [["save dead state"]],
                                                                   start_children: [],
                                                                   function: isDeadState(current_state_name:),
                                                                   function_name: "isDeadState",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                // save dead state -> advance to next state ->  name, 0
                self.name_state_table[["save dead state"]] = ContextState.init(name: ["save dead state"],
                                                                   nexts: [["increment state_id for the current level", "dead state"]],
                                                                   start_children: [],
                                                                   function: saveNewState(current_state_name:),
                                                                   function_name: "saveNewState",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


                self.name_state_table[["increment state_id for the current level", "dead state"]] = ContextState.init(name: ["increment state_id for the current level", "dead state"],
                                                                   nexts: [["advance to next state"]],
                                                                   start_children: [],
                                                                   function: incrementTheStateId(current_state_name:),
                                                                   function_name: "incrementTheStateId",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                self.name_state_table[["advance to next state"]] = ContextState.init(name: ["advance to next state"],
                                                                   nexts: [["name", "0"]],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                /*
                                save dead state
                                    Next
                                        advance to next state
                                    Function
                                        saveNewState
                                advance to next state
                                    Next
                                        name 0
                                    Function
                                        advanceLoop
                */
        

                self.name_state_table[["advance", "loop"]] = ContextState.init(name: ["advance", "loop"],
                                                                   nexts: [["is_children"], ["is_next"], /* is the next name a child name or a sibling name*/["name", "0"]],
                                                                   start_children: [],
                                                                   // is_children is asking if the current_word is "Children", same idea as with is_next
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


        
        
                self.name_state_table[["is_children"]] = ContextState.init(name: ["is_children"],
                                                                   nexts: [["save new state", "from before children"]],
                                                                   start_children: [],
                                                                   function: isChildren(current_state_name:),
                                                                   function_name: "isChildren",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
                self.name_state_table[["is_next"]] = ContextState.init(name: ["is_next"],
                                                                   nexts: [["save new state", "from before next"]],
                                                                   start_children: [],
                                                                   function: isNext(current_state_name:),
                                                                   function_name: "isNext",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])



        
                self.name_state_table[["save new state", "from before children"]] = ContextState.init(name: ["save new state", "from before children"],
                                                                   nexts: [["advance", "past children"]],
                                                                   start_children: [],
                                                                   function: saveNewState(current_state_name:),
                                                                   function_name: "saveNewState",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                self.name_state_table[["save new state", "from before next"]] = ContextState.init(name: ["save new state", "from before next"],
                                                                   nexts: [["advance", "to next state link"]],
                                                                   start_children: [],
                                                                   function: saveNewState(current_state_name:),
                                                                   function_name: "saveNewState",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


    
                self.name_state_table[["advance level"]] = ContextState.init(name: ["advance level"],
                                                                   nexts: [["name", "0"]],
                                                                   start_children: [],
                                                                   function: advanceLevel(current_state_name:),
                                                                   function_name: "advanceLevel",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
                self.name_state_table[["advance", "past children"]] = ContextState.init(name: ["advance", "past children"],
                                                                   nexts: [["advance level"]],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
        
                self.name_state_table[["advance", "to next state link"]] = ContextState.init(name: ["advance", "to next state link"],
                                                                   nexts: [["save", "next state link"]],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
        
                self.name_state_table[["save", "next state link"]] = ContextState.init(name: ["save", "next state link"],
                                                                   nexts: [["advance", "to maybe next state link"]],
                                                                   start_children: [["get the next link"]],
                                                                   function: saveNextStateLink(current_state_name:),
                                                                   function_name: "saveNextStateLink",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                        self.name_state_table[["get the next link"]] = ContextState.init(name: ["get the next link"],
                                                                                           nexts: [["add links to state"]],
                                                                                           start_children: [["name_i"]],
                                                                                           children: [["names", "next state links"], ["i"]],
                                                                                           function: returnTrue(current_state_name:),
                                                                                           function_name: "returnTrue",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: [])
        
        
                                self.name_state_table[["names", "next state links"]] = ContextState.init(name: ["names", "next state links"],
                                                                                                   nexts: [],
                                                                                                   start_children: [],
                                                                                                   function: returnTrue(current_state_name:),
                                                                                                   function_name: "returnTrue",
                                                                                                   data: Data.init(new_data: ["[String]":[String]()]),
                                                                                                   parents: [])
                                self.name_state_table[["i"]] = ContextState.init(name: ["i"],
                                                                                                   nexts: [],
                                                                                                   start_children: [],
                                                                                                   function: returnTrue(current_state_name:),
                                                                                                   function_name: "returnTrue",
                                                                                                   data: Data.init(new_data: ["Int":Int()]),
                                                                                                   parents: [])
        
                                self.name_state_table[["name_i"]] = ContextState.init(name: ["name_i"],
                                                                                                   nexts: [["name_i"], ["/"]],
                                                                                                   start_children: [["char - \\-' '"]],
                                                                                                   children: [["state name strings", "next states"]],
                                                                                                   function: returnTrue(current_state_name:),
                                                                                                   function_name: "returnTrue",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                        self.name_state_table[["state name strings", "next states"]] = ContextState.init(name: ["state name strings", "next states"],
                                                                                                   nexts: [],
                                                                                                   start_children: [],
                                                                                                   function: returnTrue(current_state_name:),
                                                                                                   function_name: "returnTrue",
                                                                                                   data: Data.init(new_data: ["String":String()]),
                                                                                                   parents: [])
        
                                        self.name_state_table[["char - \\-' '"]] = ContextState.init(name: ["char - \\-' '"],
                                                                                                   nexts: [["char - \\-' '"], ["\\"], [" ", "0"], ["input empty"]],
                                                                                                   start_children: [],
                                                                                                   function: charNotBackSlashNotWhiteSpace(current_state_name:),
                                                                                                   function_name: "charNotBackslashNotWhitespace",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                        self.name_state_table[["\\"]] = ContextState.init(name: ["\\"],
                                                                                                   nexts: [["char - \\-' '"]],
                                                                                                   start_children: [],
                                                                                                   function: backSlash(current_state_name:),
                                                                                                   function_name: "backSlash",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
        
        
        
                                       self.name_state_table[[" ", "0"]] = ContextState.init(name: [" ", "0"],
                                                                                                   nexts: [["char - \\-' '"], ["char - \\-' '", "1"], ["\\", "0"], ["\\"]],
                                                                                                   start_children: [],
                                                                                                   function: whiteSpace(current_state_name:),
                                                                                                   function_name: "whiteSpace",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                        self.name_state_table[["char - \\-' '", "1"]] = ContextState.init(name: ["char - \\-' '", "1"],
                                                                                                   nexts: [["char - \\-' '"]],
                                                                                                   start_children: [],
                                                                                                   function: collectLastSpace(current_state_name:),
                                                                                                   function_name: "collectLastSpace",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                        self.name_state_table[["/", "0"]] = ContextState.init(name: ["/", "0"],
                                                                                                   nexts: [],
                                                                                                   start_children: [],
                                                                                                   function: forwardSlash(current_state_name:),
                                                                                                   function_name: "forwardSlash",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                        self.name_state_table[["input empty"]] = ContextState.init(name: ["input empty"],
                                                                                                   nexts: [],
                                                                                                   start_children: [],
                                                                                                   function: inputHasBeenReadIn(current_state_name:),
                                                                                                   function_name: "inputHasBeenReadIn",
                                                                                                   data: Data.init(new_data: [:]),
                                                                                                   parents: [])
                                self.name_state_table[["/"]] = ContextState.init(name: ["/"],
                                                                                           nexts: [[" ", "1"]],
                                                                                           start_children: [],
                                                                                           function: advanceLoop(current_state_name:),
                                                                                           function_name: "advanceLoop",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: [])
        
                                self.name_state_table[[" ", "1"]] = ContextState.init(name: [" ", "1"],
                                                                                           nexts: [["name_i"]],
                                                                                           start_children: [],
                                                                                           function: advanceLoop(current_state_name:),
                                                                                           function_name: "advanceLoop",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: [])
                        self.name_state_table[["add links to state"]] = ContextState.init(name: ["add links to state"],
                                                                                           nexts: [],
                                                                                           start_children: [],
                                                                                           function: advanceLoop(current_state_name:),
                                                                                           function_name: "advanceLoop",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: [])
                self.name_state_table[["advance", "to maybe next state link"]] = ContextState.init(name: ["advance", "to maybe next state link"],
                                                                   nexts: [["is current word a sibling of prev word"], ["advance past", "Function"]],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                self.name_state_table[["is current word a sibling of prev word"]] = ContextState.init(name: ["is current word a sibling of prev word"],
                                                                   nexts: [["save", "next state link"]],
                                                                   start_children: [],
                                                                   function: isCurrentWordASiblingOfPrevWord(current_state_name:),
                                                                   function_name: "isCurrentWordASiblingOfPrevWord",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

                // save next state link, advance to maybe next state link, is current word a sibling of prev word?, yes: save next state link,
                // no: move on
        
                self.name_state_table[["advance past", "Function"]] = ContextState.init(name: ["advance past", "Function"],
                                                                   nexts: [["save function name"]],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


                self.name_state_table[["save function name"]] = ContextState.init(name: ["save function name"],
                                                                   nexts: [["advance", "again"]],
                                                                   start_children: [/*["get the function name"]*/],
                                                                   function: saveFunctionName(current_state_name:),
                                                                   function_name: "saveFunctionName",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                            ////  new subtree
                            self.name_state_table[["get the function name"]] = ContextState.init(name: ["get the function name"],
                                                                               nexts: [],
                                                                               start_children: [["swift function signature"], ["swift_function_name"]],
                                                                               function: saveFunctionName(current_state_name:),
                                                                               function_name: "saveFunctionName",
                                                                               data: Data.init(new_data: [:]),
                                                                               parents: [])
                                        self.name_state_table[["swift function signature"]] = ContextState.init(name: ["swift function signature"],
                                                                                       nexts: [],
                                                                                       start_children: [["letter"]],
                                                                                       function: saveFunctionName(current_state_name:),
                                                                                       function_name: "saveFunctionName",
                                                                                       data: Data.init(new_data: [:]),
                                                                                    parents: [])
                                                self.name_state_table[["letter"]] = ContextState.init(name: ["letter"],
                                                                                   nexts: [["letter"], ["letter_underscore_number"]],
                                                                                   start_children: [],
                                                                                   function: saveFunctionName(current_state_name:),
                                                                                   function_name: "saveFunctionName",
                                                                                   data: Data.init(new_data: [:]),
                                                                                   parents: [])
                                                self.name_state_table[["letter_underscore_number"]] = ContextState.init(name: ["letter_underscore_number"],
                                                                                   nexts: [["letter_underscore_number"], ["("]],
                                                                                   start_children: [],
                                                                                   function: saveFunctionName(current_state_name:),
                                                                                   function_name: "saveFunctionName",
                                                                                   data: Data.init(new_data: [:]),
                                                                                   parents: [])
                                                self.name_state_table[["("]] = ContextState.init(name: ["("],
                                                                                   nexts: [["letter", "1"]],
                                                                                   start_children: [],
                                                                                   function: saveFunctionName(current_state_name:),
                                                                                   function_name: "saveFunctionName",
                                                                                   data: Data.init(new_data: [:]),
                                                                                   parents: [])
        
                self.name_state_table[["advance", "again"]] = ContextState.init(name: ["advance", "again"],
                                                                   nexts: [["is current word a different parent of prev word"],],
                                                                   start_children: [],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


                /*
                                is current word a different parent of prev word
                                    Next
                                        is current word a state name, (is current word "Function")
                                    Function
                                        isCurrentwordADifferentParentOfPrevWord
                                (is current word "Function")
                                    Next
                                        (decrement max_stack_index by 1)
                                    Function
                                        isCurrentWordFunction
        
                                (decrement max_stack_index by 1)
                                    Next
                                        advance past | Function
                                    Function
                                        decrememntMaxStackIndex
                */
                self.name_state_table[["is current word a different parent of prev word"]] = ContextState.init(name: ["is current word a different parent of prev word"],
                                                                   nexts: [["is current word a state name"], ["is current word \"Function\""]],
                                                                   start_children: [],
                                                                   function: isCurrentwordADifferentParentOfPrevWord(current_state_name:),
                                                                   function_name: "isCurrentwordADifferentParentOfPrevWord",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])



        
                self.name_state_table[["is current word \"Function\""]] = ContextState.init(name: ["is current word \"Function\""],
                                                                   nexts: [["decrease max stack index"]],
                                                                   start_children: [],
                                                                   function: isCurrentWordFunction(current_state_name:),
                                                                   function_name: "isCurrentWordFunction",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
                self.name_state_table[["decrease max stack index"]] = ContextState.init(name: ["decrease max stack index"],
                                                                   nexts: [["advance past", "Function"]],
                                                                   start_children: [],
                                                                   function: decreaseMaxStackIndex(current_state_name:),
                                                                   function_name: "decreaseMaxStackIndex",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


        
                self.name_state_table[["is current word a state name"]] = ContextState.init(name: ["is current word a state name"],
                                                                   nexts: [["is current indent == indent for level"], ["is current indent > indent for level"]],
                                                                   start_children: [],
                                                                   function: isAStateName(current_state_name:),
                                                                   function_name: "isAStateName",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])


                self.name_state_table[["is current indent == indent for level"]] = ContextState.init(name: ["is current indent == indent for level"],
                                                                   nexts: [["delete current state name"]],
                                                                   start_children: [],
                                                                   function: isCurrentIndentSameAsIndentForLevel(current_state_name:),
                                                                   function_name: "isCurrentIndentSameAsIndentForLevel",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
                self.name_state_table[["delete current state name"]] = ContextState.init(name: ["delete current state name"],
                                                                   nexts: [["increment state_id for the current level"]],
                                                                   start_children: [],
                                                                   function: deleteCurrentStateName(current_state_name:),
                                                                   function_name: "deleteCurrentStateName",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

        
        
        
        
                self.name_state_table[["is current indent > indent for level"]] = ContextState.init(name: ["is current indent > indent for level"],
                                                                   nexts: [/*["delete the last context"]*/["increment state_id for the current level"]],
                                                                   start_children: [],
                                                                   function: isCurrentIndentGreaterThanAsIndentForLevel(current_state_name:),
                                                                   function_name: "isCurrentIndentGreaterThanAsIndentForLevel",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
        
        
        
        
        
        
                self.name_state_table[["increment state_id for the current level"]] = ContextState.init(name: ["increment state_id for the current level"],/* in the tracker and the stack[tracker]"],*/
                                                                   nexts: [["name", "0"]],
                                                                   start_children: [],
                                                                   function: incrementTheStateId(current_state_name: ),
                                                                   function_name: "incrementTheStateId",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])

        


                /*
                is the current word Function?
                yes
                advance past Function(done)
                save function name(done)
                advance again (done)
                current word is a different parent(done)
                current word is a state name
                current indent = indent for level(the current word should be a sibling state)
                update stack data and tracker data to account for sibling state(incrememnt the state id in the tracker and the stack[tracker])
         
                move to (names, 0)
         
                */

            self.name_state_table[["start_children", "0"]] = ContextState.init(name: ["start_children", "0"],
                                                               nexts: [],
                                                               start_children: [["\"Start Children\"", "0"]],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [])
        
    }
    func runParser()
    {
    
        let visitor_class: Visit = Visit.init(next_states: [["states", "state"]],
                                                  current_state_name:    ["states", "state"],
                                                  bottom:                ChildParent.init(child: ["root", "0"],
                                                                                          parent: nil),
                                                  dummy_node:            ContextState.init(name:["root", "0"],
                                                                                           nexts: [],
                                                                                           start_children: [],
                                                                                           function: returnTrue(current_state_name:),
                                                                                           function_name: "returnTrue",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: []),
                                                  name_state_table:     self.name_state_table)
            // visitStatesParser(start_state:)
        visitor_class.visitStates(start_state: self.name_state_table[["states", "state"]]!)
    }
}
