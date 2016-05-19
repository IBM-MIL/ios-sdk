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
import Alamofire

/**
 A `RestToken` object retrieves, stores, and refreshes an authentication token. The token is
 retrieved at a particular URL using basic authentication credentials (i.e. username and password).
 */
internal class RestToken {
    
    internal var token: String?
    internal var isRefreshing = false
    internal var retries = 0
    
    private var tokenURL: String
    private var username: String
    private var password: String
    
    /**
     Create a `RestToken`.
     
     - parameter tokenURL:   The URL that shall be used to obtain a token.
     - parameter username:   The username credential used to obtain a token.
     - parameter password:   The password credential used to obtain a token.
     */
    internal init(tokenURL: String, username: String, password: String) {
        self.tokenURL = tokenURL
        self.username = username
        self.password = password
    }
    
    /**
     Refresh the authentication token.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after a new token is retrieved.
     */
    internal func refreshToken(
        failure: (NSError -> Void)? = nil,
        success: (Void -> Void)? = nil)
    {
        Alamofire.request(.GET, tokenURL)
            .authenticate(user: username, password: password)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success(let token):
                    self.token = token
                    success?()
                case .Failure(let error):
                    failure?(error)
                }
            }
    }
}
