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

// Class that bridges to the Watson Speech To Text service
class ConversationSpeechToTextService {

    private let stt: SpeechToText
    private let session: NSURLSession

    init(username: String, password: String) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let auth = BasicAuthenticationStrategy(tokenURL: ConversationHelperConstants.streamTokenURL, serviceURL: ConversationHelperConstants.sttServiceURL, username: username, password: password)
        self.stt = SpeechToText(username: username, password: password)
        let session = NSURLSession(configuration: config, delegate: auth, delegateQueue: nil)
        self.session = session
    }

    /**
     Send the given audio file to the Watson Speech to Text Service and receive a transcription of it.

     - parameter file: The audio file to send.
     - settings: Settings for the Speech to Text service.
     - parameter failureHandler: A function that will be executed if the response returns an error
     - parameter successHandler: A function that will be executed with the response returned successfully
     */
    func transcribeDiscreteAudio(file: NSURL, settings: SpeechToTextOptions, failureHandler: (NSError -> Void)? , successHandler: [SpeechToTextResult] -> Void) {
        let sttSettings = settings.toSpeechToTextSettings()
        stt.transcribe(file, settings: sttSettings, failure: failureHandler, success: successHandler)
    }

    /*func transcribeContinuousAudio(mediaFormat: AudioMediaType, failureHandler: (NSError -> Void)?, successHandler: [SpeechToTextResult] -> Void) {
        var sttSettings = SpeechToTextSettings(contentType: mediaFormat)
        sttSettings.continuous = true
        sttSettings.interimResults = true
        _ = stt.transcribe(sttSettings, failure: failureHandler, success: successHandler)
    }*/

    /**
    Send the given audio file to the Watson Speech to Text Service and receive a transcription of it.

    - settings: Settings for the Speech to Text service.
    - parameter failureHandler: A function that will be executed if the response returns an error
    - parameter successHandler: A function that will be executed with the response returned successfully
    */
    func transcribeContinuousAudio(settings: SpeechToTextOptions, failureHandler: (NSError -> Void)?, successHandler: [SpeechToTextResult] -> Void) {
        let sttSettings = settings.toSpeechToTextSettings()
        _ = stt.transcribe(sttSettings, failure: failureHandler, success: successHandler)
    }

}
