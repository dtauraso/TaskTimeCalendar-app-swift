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
    
    func returnTrue(levels: [Point: ContextState], current_state_name: [String]) -> Bool
    {
        return true
    }
    func returnFalse(levels: [Point: ContextState], current_state_name: [String]) -> Bool
    {
        return false
    }
    func testing(levels: [Point: ContextState],
                 state_point_table: [[String]: Point],
                 current_state_name: [String])
                 -> Bool
    {
        var test: String = getString(dict: (levels[state_point_table[current_state_name]!]?.data)!)
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
                                                               start_children:[["names", "0"], ["indent_increase", "0"]],
                                                               parents: [["root", "0"]],
                                                               children: [["start_children"]],
                                                               nexts: [],
                                                               function: returnTrue(levels:current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: [:])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 0)]?.getName())!] = Point.init(l: 0, s: 0)
    
        self.levels[Point.init(l: 0, s: 1)] = ContextState.init(name: ["level_number"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["Int": 0])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 1)]?.getName())!] = Point.init(l: 0, s: 1)
    
        self.levels[Point.init(l: 0, s: 2)] = ContextState.init(name: ["state_id"],
                                                               start_children: [],
                                                               parents: [],
                                                               children: [],
                                                               nexts: [],
                                                               function: returnTrue(levels:current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: ["Int": 0])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 2)]?.getName())!] = Point.init(l: 0, s: 2)
    
        self.levels[Point.init(l: 0, s: 3)] = ContextState.init(name: ["prev_indent"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["Int": 0])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 3)]?.getName())!] = Point.init(l: 0, s: 3)
    
        self.levels[Point.init(l: 0, s: 4)] = ContextState.init(name: ["current_word"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["String": ""])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 4)]?.getName())!] = Point.init(l: 0, s: 4)

        self.levels[Point.init(l: 0, s: 5)] = ContextState.init(name: ["next_indent"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["Int": 0])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 5)]?.getName())!] = Point.init(l: 0, s: 5)

        /*
            prev_indent, prev_word, current_word, next_indent, what_is_current_word_to_prev_word
                                                                    child, sibling, parent
        */
        self.levels[Point.init(l: 0, s: 6)] = ContextState.init(name: ["what_is_current_word_to_prev_word"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [["child"], ["sibling"], ["parent"]],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: [:])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 6)]?.getName())!] = Point.init(l: 0, s: 6)
                // have the child, sibling, parent states
                // have a ssubmachine called advance that gets the next word and sets all this state variables
    
        self.levels[Point.init(l: 0, s: 7)] = ContextState.init(name: ["sparse_matrix"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["[Point: ContextState]": [:]])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 7)]?.getName())!] = Point.init(l: 0, s: 7)
    
    
        self.levels[Point.init(l: 0, s: 8)] = ContextState.init(name: ["input"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [],
                                                           function: returnTrue(levels:current_state_name:),
                                                           function_name: "returnTrue",
                                                           data: ["String": readFile(file: "input.txt")])
        self.state_point_table[(self.levels[Point.init(l: 0, s: 8)]?.getName())!] = Point.init(l: 0, s: 8)

        
        //print("\n\n")
    
            self.levels[Point.init(l: 1, s: 0)] = ContextState.init(name: ["names", "0"],
                                                               start_children: [["name", "0"]],
                                                               parents: [["states", "state"]],
                                                               children: [],
                                                               nexts: [["start_children", "0"]],
                                                               function: returnTrue(levels:current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: [:])
            self.state_point_table[(self.levels[Point.init(l: 1, s: 0)]?.getName())!] = Point.init(l: 1, s: 0)
    
            //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 0)] = ContextState.init(name: ["name", "0"],
                                                                   start_children: [],
                                                                   parents: [["names", "0"]],
                                                                   children: [],
                                                                   nexts: [["indent_increase", "0"],
                                                                           ["indent_decrease", "0"]],
                                                                   function: returnTrue(levels:current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 0)]?.getName())!] = Point.init(l: 2, s: 0)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 1)] = ContextState.init(name: ["indent_increase", "0"],
                                                           start_children: [],
                                                           parents: [],
                                                           children: [],
                                                           nexts: [["name", "0"], ["\"Start Children\"", "0"]],
                                                           function: returnFalse(levels:current_state_name:),
                                                           function_name: "returnFalse",
                                                           data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 1)]?.getName())!] = Point.init(l: 2, s: 1)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 2)] = ContextState.init(name: ["indent_increase", "1"],
                                                                   start_children: [],
                                                                   parents: [],
                                                                   children: [],
                                                                   nexts: [["states", "substates"]],
                                                                   function: returnTrue(levels:current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 2)]?.getName())!] = Point.init(l: 2, s: 2)
                //print("\n\n")


                // the recursion will be detected by the positive level difference between the current state and the Start Children State
                self.levels[Point.init(l: 2, s: 3)] = ContextState.init(name: ["indent_increase", "2"],
                                                                   start_children: [["names", "0"]],
                                                                   parents: [],
                                                                   children: [],
                                                                   nexts: [["indent_decrease", "1"]],
                                                                   function: returnTrue(levels:current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 3)]?.getName())!] = Point.init(l: 2, s: 3)
                //print("\n\n")

                self.levels[Point.init(l: 2, s: 4)] = ContextState.init(name: ["\"Start Children\"", "0"],
                                                                   start_children: [/*["names", "0"]*/],
                                                                   parents: [],
                                                                   children: [],
                                                                   nexts: [],
                                                                   function: returnTrue(levels:current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: [:])
                // has no neighbors the stack should shrink after this state runs

                self.state_point_table[(self.levels[Point.init(l: 2, s: 4)]?.getName())!] = Point.init(l: 2, s: 4)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 5)] = ContextState.init(name: ["indent_decrease", "0"],
                                                                   start_children: [],
                                                                   parents: [],
                                                                   children: [],
                                                                   nexts: [],
                                                                   function: returnTrue(levels:current_state_name:),
                                                                   function_name: "returnTrue",
                                                                   data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 5)]?.getName())!] = Point.init(l: 2, s: 5)
                //print("\n\n")
    
                self.levels[Point.init(l: 2, s: 6)] = ContextState.init(name: ["indent_decrease", "1"],
                                                                   start_children: [],
                                                                   parents: [],
                                                                   children: [],
                                                                   nexts: [],
                                                                   function: returnFalse(levels:current_state_name:),
                                                                   function_name: "returnFalse",
                                                                   data: [:])
                self.state_point_table[(self.levels[Point.init(l: 2, s: 6)]?.getName())!] = Point.init(l: 2, s: 6)
                //print("\n\n")
    
    
    
            self.levels[Point.init(l: 1, s: 1)] = ContextState.init(name: ["start_children", "0"],
                                                               start_children: [["\"Start Children\"", "0"]],
                                                               parents: [],
                                                               children: [],
                                                               nexts: [],
                                                               function: returnTrue(levels:current_state_name:),
                                                               function_name: "returnTrue",
                                                               data: [:])
            self.state_point_table[(self.levels[Point.init(l: 1, s: 1)]?.getName())!] = Point.init(l: 1, s: 1)
    }
    func runParser()
    {
    
            var visitor_class: Visit = Visit.init(next_states: [(self.levels[Point.init(l: 0, s: 0)]!.getName())],
                                                  current_state_name:    (self.levels[Point.init(l: 0, s: 0)]?.getName())!,
                                                  bottom:                ChildParent.init(child: ["root", "0"],
                                                                                          remaining_start_children: [],
                                                                                          parent: nil),
                                                  dummy_node:            ContextState.init(name:["root", "0"],
                                                                                           start_children: [],
                                                                                           parents: [],
                                                                                           children: [],
                                                                                           nexts: [],
                                                                                           function: returnTrue(levels:current_state_name:),
                                                                                           function_name: "returnTrue",
                                                                                           data: [:]),
                                                  state_point_table:     self.state_point_table,
                                                  levels:                self.levels)
            visitor_class.visitStates(start_state: self.levels[Point.init(l: 0, s: 0)]!,
                                      end_state: self.levels[Point.init(l: 0, s: 0)]!)
    }
}
