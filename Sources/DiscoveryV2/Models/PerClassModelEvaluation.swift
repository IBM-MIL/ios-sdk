/**
 * (C) Copyright IBM Corp. 2022.
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

/**
 An object that measures the metrics from a training run for each classification label separately.
 */
public struct PerClassModelEvaluation: Codable, Equatable {

    /**
     Class name. Each class name is derived from a value in the `answer_field` field.
     */
    public var name: String

    /**
     A metric that measures how many of the overall documents are classified correctly.
     */
    public var precision: Double

    /**
     A metric that measures how often documents that should be classified are classified.
     */
    public var recall: Double

    /**
     A metric that measures whether the optimal balance between precision and recall is reached. The F1 score can be
     interpreted as a weighted average of the precision and recall values. An F1 score reaches its best value at 1 and
     worst value at 0.
     */
    public var f1: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case precision = "precision"
        case recall = "recall"
        case f1 = "f1"
    }

}
