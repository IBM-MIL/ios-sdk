/**
 * Copyright IBM Corporation 2017
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
import RestKit

public struct ConceptsOptions: JSONDecodable,JSONEncodable {
    /// Maximum number of concepts to return
    public let limit: Int?
    /// Set this to false to hide Linked Data information in the response
    public let linkedData: Bool?

    /**
     Initialize a `ConceptsOptions` with required member variables.

     - returns: An initialized `ConceptsOptions`.
    */
    public init() {
        self.limit = nil
        self.linkedData = nil
    }

    /**
    Initialize a `ConceptsOptions` with all member variables.

     - parameter limit: Maximum number of concepts to return
     - parameter linkedData: Set this to false to hide Linked Data information in the response

    - returns: An initialized `ConceptsOptions`.
    */
    public init(limit: Int, linkedData: Bool) {
        self.limit = limit
        self.linkedData = linkedData
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ConceptsOptions` model from JSON.
    public init(json: JSON) throws {
        limit = try? json.getInt(at: "limit")
        linkedData = try? json.getBool(at: "linked_data")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ConceptsOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let limit = limit { json["limit"] = limit }
        if let linkedData = linkedData { json["linked_data"] = linkedData }
        return json
    }
}
