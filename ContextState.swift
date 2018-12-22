//
//  ContextState.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/17/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class ContextState {

    var name:           [String]
    
    var start_children: [[String]]
    
    var parents:        [[String]]
    
    var children:       [[String]]
    
    var nexts:          [[String]]
    
    var function:       ([Point: ContextState], [String]) -> Bool
    
    var function_name:  String
    
    // this should only have 1 entry as each state also can stand in as a single variable(digit, string, array, custom class)
    var data:           [String: Any]
    
    init(name:                  [String],
         start_children:        [[String]],
         parents:               [[String]],
         children:              [[String]],
         nexts:                 [[String]],
         function: @escaping    ([Point: ContextState], [String]) -> Bool,
         function_name:         String,
         data:                  [String: Any])
    {
        self.name           =   name
        self.start_children =   start_children
        self.parents        =   parents
        self.children       =   children
        self.nexts          =   nexts
        self.function       =   function
        self.function_name  =   function_name
        self.data           =   data
    }
    
    func getName() -> [String]
    {
        return self.name
    }
    func getStartChildren() -> [[String]]
    {
        return self.start_children
    }
    func getParents() -> [[String]]
    {
        return self.parents
    }
    func getChildren() -> [[String]]
    {
        return self.children
    }
    func getNexts() -> [[String]]
    {
        return self.nexts
    }
    func callFunction(levels: [Point: ContextState], current_state_name: [String]) -> Bool
    {
        return self.function(levels, current_state_name)
    }
    func getFunctionName() -> String
    {
        return self.function_name
    }
    func getInt(key: String) -> Int
    {
        return self.data[key] as! Int
    }
}
// can't use Equatable nor Hashable to find the data var in a search

extension ContextState: Equatable {
    static func == (lhs: ContextState, rhs: ContextState) -> Bool {
        return lhs.name == rhs.name &&
               lhs.start_children == rhs.start_children &&
               lhs.parents == rhs.parents &&
               lhs.children == rhs.children &&
               lhs.nexts == rhs.nexts &&
               lhs.function_name == rhs.function_name

        }
    }

extension ContextState: Hashable {
  var hashValue: Int {
    return name.hashValue ^
           start_children.hashValue ^
           parents.hashValue ^
           children.hashValue ^
           nexts.hashValue ^
           function_name.hashValue
  }
}
