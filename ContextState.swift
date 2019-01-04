//
//  ContextState.swift
//  TaskTimeCalendar-swift
//
//  Created by David on 12/17/18.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

class Data {
    
    var data:           [String: Any]
    func returnTrue(current_state_name: [String]) -> Bool
    {
        return true
    }
    init(new_data: [String: Any])
    {
        self.data = new_data
    }
    func getBool() -> Bool
    {
        let bool = self.data["Bool"] as? Bool
        if(bool != nil)
        {
            return bool!
        }

        return false

    }
    func getInt() -> Int
    {
        let int = self.data["Int"] as? Int
        if(int != nil)
        {
            return int!
        }

        return -123
        
    }
    // there should only be 1 value in [String: Any] per state
    func getString() -> String
    {
        let string = self.data["String"] as? String
        if(string != nil)
        {
            return string!
        }

        return "no String type is here"
    }
    func getStringList() -> [String]
    {
        let string_list = self.data["[String]"] as? [String]
        if(string_list != nil)
        {
            return string_list!
        }

        return ["no [String] type is here"]
    }
    func getPoint() -> Point
    {
        let point = self.data["Point"] as? Point
        if(point != nil)
        {
            return point!
        }

        return Point.init(l: -1, s: -1)

    }
    func getPointFromStringListToPointEntry(key: [String]) -> Point
    {
        var entry = self.data["[[String]: Point]"] as? [[String]: Point]
        if(entry != nil)
        {
            return entry![key]!
        }
        return Point.init(l: -1, s: -1)
    }
    func getContextStateFromPointToContextState(key: Point) -> ContextState
    {
        var entry = self.data["[Point: ContextState]"] as? [Point: ContextState]
        if(entry != nil)
        {
            return entry![key]!
        }
        return ContextState.init(name: ["nil"], function: returnTrue(current_state_name:))
    }
    func setBool(value: Bool) -> Bool
    {
        self.data["Bool"] = value
        return true
    }
    func setInt(value: Int) -> Bool
    {
        self.data["Int"] = value
        return true
    }
    
    func setString(value: String) -> Bool
    {
        self.data["String"] = value
        return true
    }
    func setStringList(value: [String]) -> Bool
    {
        self.data["[String]"] = value
        return true
    }
    
    func appendString(value: String) -> Bool
    {
        var string_list = self.data["[String]"] as! [String]
        //print(value)
        string_list.append(value)
        //print(string_list)
        self.data["[String]"] = string_list
        return true
    }
    func setPoint(value: Point) -> Bool
    {
        self.data["Point"] = value
        return true
    }
    
    func setStringListToPointEntry(key: [String], value: Point) -> Bool
    {
        var dict = (self.data["[[String]: Point]"] as! [[String]: Point])
        dict[key] = value
        self.data["[[String]: Point]"] = dict
        return true
    }
    func setPointToContextState(key: Point, value: ContextState) -> Bool
    {
        var dict = (self.data["[Point: ContextState]"] as! [Point: ContextState])
        dict[key] = value
        self.data["[Point: ContextState]"] = dict
        return true

    }
}

class ContextState {

    var name:           [String]
    
    var start_children: [[String]]
    
    var parents:        [[String]]
    
    
    var nexts:          [[String]]
    
    var function:       ([String]) -> Bool
    
    var function_name:  String
    
    // this should only have 1 entry as each state also can stand in as a single variable(digit, string, array, custom class)
    var data:           Data

    init(name:                  [String],
         start_children:        [[String]],
         nexts:                 [[String]],
         function: @escaping    ([String]) -> Bool,
         function_name:         String,
         data:                  Data,
         parents:               [[String]])
    {
        self.name           =   name
        self.start_children =   start_children
        self.nexts          =   nexts
        self.function       =   function
        self.function_name  =   function_name
        self.data           =   data
        self.parents        =   parents

    }
    init(name: [String], function: @escaping ([String]) -> Bool)
    {
        self.name = name
        self.start_children =   []
        self.nexts          =   []
        self.function       =   function
        self.function_name  =   ""
        self.data           =   Data.init(new_data: [:])
        self.parents        =   []
    }
    func makeIndentString(indent_level: Int) -> String
    {
        var indent_string: String = String()
        var indent = indent_level
        while(indent > 0)
        {
            indent_string.append(" ")
            indent -= 1
        }
        return indent_string
    }
    func Print(indent_level: Int)
    {
        let indent_string = makeIndentString(indent_level: indent_level)
        
        print(indent_string, self.name)
        print(indent_string, self.start_children)
        print(indent_string, self.nexts)
        print(indent_string, self.function_name)
        print(indent_string, self.data)
        print(indent_string, self.parents)
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
    func getNexts() -> [[String]]
    {
        return self.nexts
    }
    func callFunction(current_state_name: [String]) -> Bool
    {
        return self.function(current_state_name)
    }
    func getFunctionName() -> String
    {
        return self.function_name
    }
    func getData() -> Data
    {
        return self.data
    }
    
}


