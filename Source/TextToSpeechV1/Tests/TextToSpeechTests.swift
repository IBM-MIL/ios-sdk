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

import XCTest
import WatsonDeveloperCloud
import AVFoundation

class TextToSpeechTests: XCTestCase {
    
    private var textToSpeech: TextToSpeechV1!
    private let timeout: NSTimeInterval = 30
    private let playAudio = true
    private let text = "Swift at IBM is awesome so you should try it!"
    
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
    
    /** Get a synthesize some text with given voice type */
    func synthesize(text:String,
                    accept:TextToSpeechV1.AcceptFormat,
                    voiceType: TextToSpeechV1.VoiceType? = nil,
                    customizationID: String? = nil,
                    format: TextToSpeechV1.PhonemeFormat? = nil) -> NSData? {
        
        let description = "synthesize"
        let expectation = expectationWithDescription(description)
        var audioData: NSData?
        
        textToSpeech.synthesize(text,accept: accept,voiceType: voiceType,customizationID: customizationID, failure: failWithError ) { value in
            audioData = value
            expectation.fulfill()
        }

        waitForExpectations()
        return audioData
    }
    
    
    // MARK: - Positive Tests
    
    /** Test getting a pronunciation with invalid voice type. */
    func testSynthisize() {
        
        guard let synthesized = synthesize(text,
                                           accept: TextToSpeechV1.AcceptFormat.wav,
                                           voiceType: TextToSpeechV1.VoiceType.defined(TextToSpeechV1.DefinedVoiceType.GB_KATE))
            else {
                XCTFail("Failed to get a list of voices.")
                return
        }
        
        XCTAssertNotNil(synthesized, "Should be some data present")
        
        do {
            let audioPlayer = try AVAudioPlayer(data: synthesized)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            if (self.playAudio) {
                sleep(10)
            }
            
        } catch {
            XCTAssertTrue(false, "Could not initialize the AVAudioPlayer with the received data.")
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
    
    /** Test getting a pronunciation.  This will test all available voices*/
    func testGetPronunciationWithDefinedVoice() {
        
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
                voiceType: TextToSpeechV1.VoiceType.defined(voiceType),
                format: format) else {
                    XCTFail("Failed to get a pronunciation for \(voiceType).")
                    continue
            }
            if (voiceType != TextToSpeechV1.DefinedVoiceType.JP_Emi) {
                XCTAssertGreaterThanOrEqual(pronunciation.pronunciation.characters.count, 1, "Expected there to be at least 1 character.")
            }
        }
    }
    
    // MARK: - Negative Tests
    
    /** Test getting a pronunciation with invalid voice type. */
    func testGetPronunciationWithUndefinedVoice() {
        
        let description = "Test undefined voice in pronunciation all."
        let expectation = expectationWithDescription(description)
        
        let text = "Swift at IBM is awesome"
        
        let format = TextToSpeechV1.PhonemeFormat.spr
        let customVoice = TextToSpeechV1.VoiceType.custom("does_not_exist")
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        textToSpeech.getPronunciation(text, voiceType: customVoice, format: format, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Test getting a voice with invalid voice type. */
    func testGetVoiceWithUndefinedVoice() {
        
        let description = "Test undefined voice in pronunciation all."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        textToSpeech.getVoice("does_not_exist", customizationID: nil, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}


