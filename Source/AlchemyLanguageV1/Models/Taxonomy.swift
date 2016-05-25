/**
 * Copyright IBM Corporation 2015
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

/**
 
 **Taxonomy**
 
 Child class of Taxonomies
 
 */

public struct Taxonomy: JSONDecodable {
    public let confident: String?
    public let label: String?
    public let score: Double?
    
    public init(json: JSON) throws {
        confident = try? json.string("confident")
        label = try? json.string("label")
        if let scoreString = try? json.string("score") {
            score = Double(scoreString)
        } else {
            score = nil
        }
    }
}

