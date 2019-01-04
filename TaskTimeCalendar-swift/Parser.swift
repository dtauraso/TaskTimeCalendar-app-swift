//
//  Parser.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/23/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class Parser {
    
    var levels: [Point: ContextState] = [Point: ContextState]()
    var state_point_table: [[String]: Point] = [[String]: Point]()
    func getState(current_state_name: [String]) -> ContextState
    {
        if(state_point_table[current_state_name] != nil)
        {
            return levels[state_point_table[current_state_name]!]!

        }
        print("no state by ", current_state_name, "is in state_point_table")
        exit(0)
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
        var input: String = getState(current_state_name: ["input"]).getData().getString()
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
        //print(input[index])
        i += index.encodedOffset
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
        //print("here")
        //print(getState(current_state_name: ["current_word"]).getString())
        let state_name_progress = getState(current_state_name: ["current_word"]).getData().getString()
        //print( getState(current_state_name: ["name", "state_name"]).getStringList())
        getState(current_state_name: ["name", "state_name"]).getData().appendString(value: state_name_progress)
        //print(getState(current_state_name: ["name", "state_name"]).getStringList())
        //exit(0)
        return true
    }
    func advanceLoop(current_state_name: [String]) -> Bool
    {
        //print("in advanceLoop")
        var i: Int = getState(current_state_name: ["i"]).getData().getInt()
        var input: String = getState(current_state_name: ["input"]).getData().getString()
        var next_indent = getState(current_state_name: ["next_indent"]).getData().getInt()
        var prev_indent = getState(current_state_name: ["prev_indent"]).getData().getInt()
        var current_word = getState(current_state_name: ["current_word"]).getData().getString()
        var prev_word = getState(current_state_name: ["prev_word"]).getData().getString()
        print(input)
        var index = input.index(input.startIndex, offsetBy: String.IndexDistance(i))
        //print(input[index])
        //print(prev_indent, next_indent)
        var word: String = String()
        
        while(input[index] != "\n")
        {
            word.append(input[index])
            index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1) )
        }
        //print(word)
        index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))

        var indent_count: Int = Int()
        while(input[index] == "\t")
        {
            indent_count += 1
            index = input.index(input.startIndex, offsetBy: String.IndexDistance(index.encodedOffset + 1))
            
        }
        swap(&next_indent, &prev_indent)
        swap(&current_word, &prev_word)
        current_word = word
        //print(prev_word, current_word)
        //print(indent_count)
        next_indent = indent_count
        i += index.encodedOffset
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
        }
        //print(i)
        //print(prev_indent, next_indent)
        
        getState(current_state_name: ["i"]).getData().setInt(value: i)
        getState(current_state_name: ["prev_word"]).getData().setString(value: prev_word)

        getState(current_state_name: ["current_word"]).getData().setString(value: current_word)
        getState(current_state_name: ["prev_indent"]).getData().setInt(value: prev_indent)

        getState(current_state_name: ["next_indent"]).getData().setInt(value: next_indent)

        //print(getState(current_state_name: ["i"]).getData().getInt())
        //print(getState(current_state_name: ["prev_word"]).getData().getString(), getState(current_state_name: ["current_word"]).getData().getString())
        
        //print(getState(current_state_name: ["prev_indent"]).getData().getInt(), getState(current_state_name: ["next_indent"]).getData().getInt())

        //exit(0)
        return true
    }
    func isChildren(current_state_name: [String]) -> Bool
    {
        return getState(current_state_name: ["current_word"]).getData().getString() == "Children"

    }
    func saveNewState(current_state_name: [String]) -> Bool
    {
        print("here")
        let collected_state_name = getState(current_state_name: ["name", "state_name"]).getData().getStringList()
        //print(getState(current_state_name: ["name", "state_name"]).getData().getStringList())
        let level = getState(current_state_name: ["level_id"]).getData().getInt()
        //print(level)
        let state = getState(current_state_name: ["state_id"]).getData().getInt()
        //print(state)
        //print(getState(current_state_name: ["child"]).getData().getBool())

        let new_state = ContextState.init(name: collected_state_name, function: returnTrue(current_state_name:))
        //new_state.Print()
        // point_table "[[String]: Point]"
        getState(current_state_name: ["point_table"]).getData().setStringListToPointEntry(key: collected_state_name,
                                                                                          value: Point.init(l: level, s: state))

        
        // sparse_matrix "[Point: ContextState]"
        getState(current_state_name: ["sparse_matrix"]).getData().setPointToContextState(key: Point.init(l: level, s: state),
                                                                                         value: new_state)
        let point = getState(current_state_name: ["point_table"]).getData().getPointFromStringListToPointEntry(key: collected_state_name)
        //print(point)

        let context_state = getState(current_state_name: ["sparse_matrix"]).getData().getContextStateFromPointToContextState(key: point)
        //print(context_state)
        context_state.Print(indent_level: level)
        exit(0)
        return true
    }
    func testing(current_state_name: [String]) -> Bool
    {
        var test: String = self.levels[self.state_point_table[current_state_name]!]!.getData().getString()
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
        self.levels[Point.init(l: 0, s: 0)] = ContextState.init(name: ["states", "state"],
                                                               start_children:[["names", "0"]],
                                                               nexts: [],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [["root", "0"]])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 0)]?.getName())!] = Point.init(l: 0, s: 0)
    
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
        self.levels[Point.init(l: 0, s: 1)] = ContextState.init(name: ["level_id"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [] )
        self.state_point_table[(self.levels[Point.init(l: 0, s: 1)]?.getName())!] = Point.init(l: 0, s: 1)
    
        self.levels[Point.init(l: 0, s: 2)] = ContextState.init(name: ["state_id"],
                                                               start_children: [],
                                                               nexts: [],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: ["Int": 0]),
                                                               parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 2)]?.getName())!] = Point.init(l: 0, s: 2)
    
        self.levels[Point.init(l: 0, s: 3)] = ContextState.init(name: ["prev_indent"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 3)]?.getName())!] = Point.init(l: 0, s: 3)
    
    
        self.levels[Point.init(l: 0, s: 4)] = ContextState.init(name: ["prev_word"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": "root"]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 4)]?.getName())!] = Point.init(l: 0, s: 4)
    
    
        self.levels[Point.init(l: 0, s: 5)] = ContextState.init(name: ["current_word"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": ""]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 5)]?.getName())!] = Point.init(l: 0, s: 5)

        self.levels[Point.init(l: 0, s: 6)] = ContextState.init(name: ["next_indent"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 6)]?.getName())!] = Point.init(l: 0, s: 6)

        /*
            prev_indent, prev_word, current_word, next_indent, what_is_current_word_to_prev_word
                                                                    child, sibling, parent
        */
        // (0, 10),  i
        
        
        // variables
        //////
        self.levels[Point.init(l: 0, s: 7)] = ContextState.init(name: ["i"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["Int": 0]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 7)]?.getName())!] = Point.init(l: 0, s: 7)


        self.levels[Point.init(l: 0, s: 8)] = ContextState.init(name: ["what_is_current_word_to_pre_word"],
                                                           start_children: [["child"], ["sibling"], ["new_parent"]],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 8)]?.getName())!] = Point.init(l: 0, s: 8)
        
            // child
                self.levels[Point.init(l: 1, s: 0)] = ContextState.init(name: ["child"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
                self.state_point_table[(self.levels[Point.init(l: 1, s: 0)]?.getName())!] = Point.init(l: 1, s: 0)

            // sibling
                self.levels[Point.init(l: 1, s: 1)] = ContextState.init(name: ["sibling"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
                self.state_point_table[(self.levels[Point.init(l: 1, s: 1)]?.getName())!] = Point.init(l: 1, s: 1)

            // parent
                self.levels[Point.init(l: 1, s: 2)] = ContextState.init(name: ["new_parent"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
                self.state_point_table[(self.levels[Point.init(l: 1, s: 2)]?.getName())!] = Point.init(l: 1, s: 2)
        ///////
        
        self.levels[Point.init(l: 0, s: 9)] = ContextState.init(name: ["advance", "init"],
                                                           start_children: [],
                                                           nexts: [["name", "0"]],
                                                           function: advanceInit(current_state_name:),
                                                           function_name: "advanceInit",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [["names", "0"]])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 9)]?.getName())!] = Point.init(l: 0, s: 9)

        // advance
            // advance states
                // have the child, sibling, parent states
                // have a ssubmachine called advance that gets the next word and sets all this state variables
        self.levels[Point.init(l: 0, s: 10)] = ContextState.init(name: ["sparse_matrix"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["[Point: ContextState]": [:]]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 10)]?.getName())!] = Point.init(l: 0, s: 10)
    
        
    
        self.levels[Point.init(l: 0, s: 11)] = ContextState.init(name: ["input"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["String": readFile(file: "input.txt")]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 11)]?.getName())!] = Point.init(l: 0, s: 11)
        
        self.levels[Point.init(l: 0, s: 12)] = ContextState.init(name: ["point_table"],
                                                           start_children: [],
                                                           nexts: [],
                                                           function: returnTrue(current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: Data.init(new_data: ["[[String]: Point]": [:]]),
                                                           parents: [])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 12)]?.getName())!] = Point.init(l: 0, s: 12)

        ///////////
        
        //print("\n\n")
            // "advance to names at 0"
        //print((self.levels[Point.init(l: 0, s: 8)]?.getString())!)
            self.levels[Point.init(l: 1, s: 3)] = ContextState.init(name: ["names", "0"],
                                                               start_children: [["advance", "init"]],
                                                               nexts: [],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [["states", "state"]])
        
            self.state_point_table[(self.levels[Point.init(l: 1, s: 3)]?.getName())!] = Point.init(l: 1, s: 3)
    
            //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 0)] = ContextState.init(name: ["name", "0"],
                                                                   start_children: [],
                                                                   nexts: [["advance", "loop"]],
                                                                   function: collectName(current_state_name:),
                                                                   function_name: "collectName",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [["names", "0"]])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 0)]?.getName())!] = Point.init(l: 2, s: 0)
        
        
        
                //print("\n\n")
                // "name", "state_name"
                self.levels[Point.init(l: 2, s: 1)] = ContextState.init(name: ["name", "state_name"],
                                                                   start_children: [],
                                                                   nexts: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: ["[String]":[]]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 1)]?.getName())!] = Point.init(l: 2, s: 1)

    
                self.levels[Point.init(l: 2, s: 2)] = ContextState.init(name: ["indent_increase", "0"],
                                                           start_children: [],
                                                           nexts: [["name", "0"], ["\"Start Children\"", "0"]],
                                                           function: returnFalse(current_state_name:),
                                                           function_name: "returnFalse",
                                                           data: Data.init(new_data: [:]),
                                                           parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 2)]?.getName())!] = Point.init(l: 2, s: 2)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 3)] = ContextState.init(name: ["indent_increase", "1"],
                                                                   start_children: [],
                                                                   nexts: [["states", "substates"]],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 3)]?.getName())!] = Point.init(l: 2, s: 3)
                //print("\n\n")


                // the recursion will be detected by the positive level difference between the current state and the Start Children State
                self.levels[Point.init(l: 2, s: 4)] = ContextState.init(name: ["indent_increase", "2"],
                                                                   start_children: [["names", "0"]],
                                                                   nexts: [["indent_decrease", "1"]],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 4)]?.getName())!] = Point.init(l: 2, s: 4)
                //print("\n\n")

                self.levels[Point.init(l: 2, s: 5)] = ContextState.init(name: ["\"Start Children\"", "0"],
                                                                   start_children: [],
                                                                   nexts: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                // has no neighbors the stack should shrink after this state runs

                self.state_point_table[(self.levels[Point.init(l: 2, s: 5)]?.getName())!] = Point.init(l: 2, s: 5)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 6)] = ContextState.init(name: ["indent_decrease", "0"],
                                                                   start_children: [],
                                                                   nexts: [],
                                                                   function: returnTrue(current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 6)]?.getName())!] = Point.init(l: 2, s: 6)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 7)] = ContextState.init(name: ["indent_decrease", "1"],
                                                                   start_children: [],
                                                                   nexts: [],
                                                                   function: returnFalse(current_state_name:),
                                                                   function_name: "returnFalse",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 7)]?.getName())!] = Point.init(l: 2, s: 7)
                //print("\n\n")
                self.levels[Point.init(l: 2, s: 8)] = ContextState.init(name: ["advance", "loop"],
                                                                   start_children: [],
                                                                   nexts: [["is_children"], ["name", "0"]],
                                                                   function: advanceLoop(current_state_name:),
                                                                   function_name: "advanceLoop",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 8)]?.getName())!] = Point.init(l: 2, s: 8)

                self.levels[Point.init(l: 2, s: 9)] = ContextState.init(name: ["is_children"],
                                                                   start_children: [],
                                                                   nexts: [["save new state"]],
                                                                   function: isChildren(current_state_name:),
                                                                   function_name: "isChildren",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 9)]?.getName())!] = Point.init(l: 2, s: 9)

                self.levels[Point.init(l: 2, s: 9)] = ContextState.init(name: ["save new state"],
                                                                   start_children: [],
                                                                   nexts: [],
                                                                   function: saveNewState(current_state_name:),
                                                                   function_name: "saveNewState",
                                                                   data: Data.init(new_data: [:]),
                                                                   parents: [])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 9)]?.getName())!] = Point.init(l: 2, s: 9)

    
            self.levels[Point.init(l: 1, s: 4)] = ContextState.init(name: ["start_children", "0"],
                                                               start_children: [["\"Start Children\"", "0"]],
                                                               nexts: [],
                                                               function: returnTrue(current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: Data.init(new_data: [:]),
                                                               parents: [])
            self.state_point_table[(self.levels[Point.init(l: 1, s: 4)]?.getName())!] = Point.init(l: 1, s: 4)
            
    }
    func runParser()
    {
    
            var visitor_class: Visit = Visit.init(next_states: [(self.levels[Point.init(l: 0, s: 0)]!.getName())],
                                                  current_state_name:    (self.levels[Point.init(l: 0, s: 0)]?.getName())!,
                                                  bottom:                ChildParent.init(child: ["root", "0"],
                                                                                          parent: nil),
                                                  dummy_node:            ContextState.init(name:["root", "0"],
                                                                                           start_children: [],
                                                                                           nexts: [],
                                                                                           function: returnTrue(current_state_name:),
                                                                                           function_name: "returnTrue",
                                                                                           data: Data.init(new_data: [:]),
                                                                                           parents: []),
                                                  state_point_table:     self.state_point_table,
                                                  levels:                self.levels)
            visitor_class.visitStates(start_state: self.levels[Point.init(l: 0, s: 0)]!,
                                      end_state: self.levels[Point.init(l: 2, s: 4)]!)
    }
}
