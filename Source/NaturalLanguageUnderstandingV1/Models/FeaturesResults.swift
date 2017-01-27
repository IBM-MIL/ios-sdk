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

/** Analysis results for each requested feature */
public struct FeaturesResults: JSONDecodable,JSONEncodable {
    public let concepts: [ConceptsResult]?
    public let entities: [EntitiesResult]?
    public let keywords: [KeywordsResult]?
    public let categories: [CategoriesResult]?
    public let emotion: [EmotionResult]?
    public let metadata: Any?
    public let relations: [RelationsResult]?
    public let semanticRoles: [SemanticRolesResult]?
    public let sentiment: [SentimentResult]?

    /**
     Initialize a `FeaturesResults` with required member variables.

     - returns: An initialized `FeaturesResults`.
    */
    public init() {
        self.concepts = nil
        self.entities = nil
        self.keywords = nil
        self.categories = nil
        self.emotion = nil
        self.metadata = nil
        self.relations = nil
        self.semanticRoles = nil
        self.sentiment = nil
    }

    /**
    Initialize a `FeaturesResults` with all member variables.

     - parameter concepts: 
     - parameter entities: 
     - parameter keywords: 
     - parameter categories: 
     - parameter emotion: 
     - parameter metadata: 
     - parameter relations: 
     - parameter semanticRoles: 
     - parameter sentiment: 

    - returns: An initialized `FeaturesResults`.
    */
    public init(concepts: [ConceptsResult], entities: [EntitiesResult], keywords: [KeywordsResult], categories: [CategoriesResult], emotion: [EmotionResult], metadata: Any, relations: [RelationsResult], semanticRoles: [SemanticRolesResult], sentiment: [SentimentResult]) {
        self.concepts = concepts
        self.entities = entities
        self.keywords = keywords
        self.categories = categories
        self.emotion = emotion
        self.metadata = metadata
        self.relations = relations
        self.semanticRoles = semanticRoles
        self.sentiment = sentiment
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `FeaturesResults` model from JSON.
    public init(json: JSON) throws {
        concepts = try? json.decodedArray(at: "concepts", type: ConceptsResult.self)
        entities = try? json.decodedArray(at: "entities", type: EntitiesResult.self)
        keywords = try? json.decodedArray(at: "keywords", type: KeywordsResult.self)
        categories = try? json.decodedArray(at: "categories", type: CategoriesResult.self)
        emotion = try? json.decodedArray(at: "emotion", type: EmotionResult.self)
        metadata = try? json.getJSON(at: "metadata")
        relations = try? json.decodedArray(at: "relations", type: RelationsResult.self)
        semanticRoles = try? json.decodedArray(at: "semantic_roles", type: SemanticRolesResult.self)
        sentiment = try? json.decodedArray(at: "sentiment", type: SentimentResult.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `FeaturesResults` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let concepts = concepts {
            json["concepts"] = concepts.map { conceptsElem in conceptsElem.toJSONObject() }
        }
        if let entities = entities {
            json["entities"] = entities.map { entitiesElem in entitiesElem.toJSONObject() }
        }
        if let keywords = keywords {
            json["keywords"] = keywords.map { keywordsElem in keywordsElem.toJSONObject() }
        }
        if let categories = categories {
            json["categories"] = categories.map { categoriesElem in categoriesElem.toJSONObject() }
        }
        if let emotion = emotion {
            json["emotion"] = emotion.map { emotionElem in emotionElem.toJSONObject() }
        }
        if let metadata = metadata { json["metadata"] = metadata }
        if let relations = relations {
            json["relations"] = relations.map { relationsElem in relationsElem.toJSONObject() }
        }
        if let semanticRoles = semanticRoles {
            json["semantic_roles"] = semanticRoles.map { semanticRolesElem in semanticRolesElem.toJSONObject() }
        }
        if let sentiment = sentiment {
            json["sentiment"] = sentiment.map { sentimentElem in sentimentElem.toJSONObject() }
        }
        return json
    }
}
