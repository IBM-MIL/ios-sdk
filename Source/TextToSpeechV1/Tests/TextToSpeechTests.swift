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

import XCTest
import WatsonDeveloperCloud

class TextToSpeechTests: XCTestCase {
    
    private var textToSpeech: TextToSpeechV1!
    private let timeout: NSTimeInterval = 30
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
    }
    
    /** Instantiate Natural Langauge Classifier instance. */
    func instantiateTextToSpeech() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["TextToSpeechUsername"],
            let password = credentials["TextToSpeechPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        textToSpeech = TextToSpeechV1(username: username, password: password)
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    /** Get all voices. */
    func testGetVoices() {
        
        guard let voices = getVoices() else {
            XCTFail("Failed to get a list of voices.")
            return
        }
        XCTAssertGreaterThanOrEqual(voices.count, 5, "Expected there to be at least 5 lanugagues.")
    }

    
    /** Test getting a voice and testing url vs name.  This will test all available voices*/
    func testGetVoice() {
        
        guard let voices = getVoices() else {
            XCTFail("Failed to get a list of voices.")
            return
        }
        for voiceInstance in voices {
            guard let voice = getVoice(voiceInstance.name) else {
                XCTFail("Failed to get a known voice \(voiceInstance.name)")
                return
            }
            
            guard voice.url.lowercaseString.rangeOfString(voice.name.lowercaseString) != nil else {
                XCTFail("Failed to match a known voice name \(voiceInstance.name)")
                return
            }
        }
    }
    
    /** Test getting a voice and testing url vs name.  This will test all available voices*/
    func testGetPronunciation() {
        
        let text = "Swift at IBM is awesome"
        
        for voiceType in TextToSpeechV1.DefinedVoiceType.allValues {
            
            print("Testing voice type \(voiceType)")
            
            let format = TextToSpeechV1.PhonemeFormat.spr
            
            // these voices fail on server
            if voiceType == TextToSpeechV1.DefinedVoiceType.BR_Isabela ||
               voiceType == TextToSpeechV1.DefinedVoiceType.IT_Francesca {
                continue
            }
            
            guard let pronunciation = getPronunciation(
                text,
                voiceType: TextToSpeechV1.VoiceType.Defined(voiceType),
                format: format) else {
                    XCTFail("Failed to get a pronunciation for \(voiceType).")
                    continue
            }
            if (voiceType != TextToSpeechV1.DefinedVoiceType.JP_Emi) {
                XCTAssertGreaterThanOrEqual(pronunciation.pronunciation.characters.count, 1, "Expected there to be at least 1 character.")
            }
        }
    }
    
    
    /** Gets all of the voices available from service */
    private func getVoices() -> [TextToSpeechV1.Voice]? {
        let description = "Get all voices."
        let expectation = expectationWithDescription(description)
        var voiceList: [TextToSpeechV1.Voice]?
        
        textToSpeech.getVoices(failWithError) { voices in
            voiceList = voices
            expectation.fulfill()
        }
        
        waitForExpectations()
        return voiceList
    }
    
    /** Get a voice by a voice name. */
    private func getVoice(voiceName: String, customizationID: String? = nil) -> TextToSpeechV1.Voice? {
        let description = "Get a voice."
        let expectation = expectationWithDescription(description)
        var voice: TextToSpeechV1.Voice?
        
        textToSpeech.getVoice(voiceName, customizationID: customizationID, failure: failWithError) { voiceInstance in
            voice = voiceInstance
            expectation.fulfill()
        }
        waitForExpectations()
        return voice
    }

    /** Get a pronunciation by a voice type name. */
    private func getPronunciation(text:String,
                          voiceType: TextToSpeechV1.VoiceType? = nil,
                          format: TextToSpeechV1.PhonemeFormat? = nil) -> TextToSpeechV1.Pronunciation? {
        
        let description = "Get pronunciation."
        let expectation = expectationWithDescription(description)
        var pronunciation: TextToSpeechV1.Pronunciation?
        
        textToSpeech.getPronunciation(text, voiceType: voiceType, format: format, failure: failWithError) { pronunciationInstance in
            pronunciation = pronunciationInstance
            expectation.fulfill()
        }
        waitForExpectations()
        return pronunciation
    }
}


