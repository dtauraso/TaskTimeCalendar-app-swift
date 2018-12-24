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

// there should only be 1 value in [String: Any] per state
func getString(dict: [String: Any]) -> String
{
    if(dict["String"] as? String != nil)
    {
        return dict["String"] as! String
    }
    else
    {
        return "no String type is here"
    }
}

func setString( dict: inout [String: Any], value: String, type: String)
{
    dict[type] = value
}


func getInt(dict: [String: Any]) -> Int
{
    if(dict["Int"] as? Int != nil)
    {
        return dict["Int"] as! Int
    }
    else
    {
        // "data not found", like webpage not found
        return 404
    }
}

func setInt( dict: inout [String: Any], value: Int, type: String)
{
    dict[type] = value
}
