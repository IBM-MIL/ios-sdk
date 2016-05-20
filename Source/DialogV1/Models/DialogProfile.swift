/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Freddy
    
/** A dialog profile. */
public struct Profile: JSONEncodable, JSONDecodable {
    
    /// The client identifier.
    public let clientID: Int?
    
    /// The parameters of the profile.
    public let parameters: [Parameter]

    public init(clientID: Int? = nil, parameters: [String: String]) {
        self.clientID = clientID
        self.parameters = parameters.map { (name, value) in
            Parameter(name: name, value: value)
        }
    }

    public init(json: JSON) throws {
        clientID = try? json.int("client_id")
        parameters = try json.arrayOf("name_values", type: Parameter.self)
    }

    public func toJSON() -> JSON {
        var json = [String: JSON]()
        if let clientID = clientID { json["client_id"] = .Int(clientID) }
        json["parameters"] = .Array(parameters.map { parameter in parameter.toJSON() })
        return JSON.Dictionary(json)
    }
}

/** A dialog parameter. */
public struct Parameter: JSONEncodable, JSONDecodable {
    
    /// The name of the parameter.
    public let name: String
    
    /// The value of the parameter.
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }

    public init(json: JSON) throws {
        name = try json.string("name")
        value = try json.string("value")
    }

    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["name"] = .String(name)
        json["value"] = .String(value)
        return JSON.Dictionary(json)
    }
}
