//
//  TestBCAUITests.swift
//  TestBCAUITests
//
//  Created by reyhan muhammad on 2025/6/29.
//

import XCTest

final class TestBCAUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testHomeViewDisplayingData() async throws {
        // MARK: Test UI by displaying the dummy data
        let app = XCUIApplication()
        app.launchArguments = [UITestingType.testingHomeViewDisplayingData.rawValue]
        app.launch()
        let dummyRepository = MockHomePersistence()
        let audios = try await dummyRepository.loadAudio(keyword: "")
        let titles = audios.map { $0.title }
        for element in titles{
            let text = app.staticTexts[element]
            XCTAssertTrue(text.waitForExistence(timeout: 5))
        }
    }
    
    @MainActor
    func testSearching() async throws {
        // MARK: Test UI for Searching
        let app = XCUIApplication()
        app.launchArguments = [UITestingType.testingOpeningSearchingUI.rawValue]
        app.launch()
        let dummyRepository = MockHomePersistence()
        //load the dummy data that the App is going to use
        let audios = try await dummyRepository.loadAudio(keyword: nil)
        let titles = audios.map { $0.title }
        
        //check if textfield exist
        let textField = app.textFields["searchTextField"]
        XCTAssert(textField.exists)
        if let audio = audios.first, let lastAudio = audios.last{
            
            //make sure that at first, the view shows all audio
            let lastText = app.staticTexts[lastAudio.title]
            XCTAssertTrue(lastText.waitForExistence(timeout: 2))
            
            //paste the first audio name on search bar
            UIPasteboard.general.string = audio.title
            textField.press(forDuration: 1.1)
            app.menuItems["Paste"].tap()
            
            //The first Audio should still be there
            let searchedText = app.staticTexts[audio.title]
            XCTAssertTrue(searchedText.waitForExistence(timeout: 1))
            
            //The last audio should no longer exist
            let otherLastText = app.staticTexts[lastAudio.title]
            XCTAssertFalse(otherLastText.waitForExistence(timeout: 1))
        }
    }
    
    @MainActor
    func testPlayingTheFirstAudio() async throws {
        //MARK: Test the playing the first audio, and make sure all the UI is there
        let app = XCUIApplication()
        app.launchArguments = [UITestingType.testingPlayingTheFirstAudio.rawValue]
        app.launch()
        //After the app launch, we are going to check if next track button does not exist.
        //as a sign that it did not play any audio
        let nextButton = app.images["nextTrackButton"]
        XCTAssertTrue(!nextButton.exists)
        let dummyRepository = MockHomePersistence()
        //We load audios from DummyRepository that the UI use and select the first one
        let audios = try await dummyRepository.loadAudio(keyword: nil)
        let titles = audios.map { $0.title }
        if let title = titles.first{
            let text = app.staticTexts[title]
            text.tap()
            //The waveform (playing icon on the song) have a Identifier of title + isPlaying
            //So, if it exist, that means we are selecting the right audio to play
            let waveformImage = app.images[title + "isPlaying"]
            XCTAssertTrue(waveformImage.waitForExistence(timeout: 5))

            //The previous button should not exist if you are playing the first element
            let previousButton = app.images["previousTrackButton"]
            XCTAssertFalse(previousButton.waitForExistence(timeout: 5))
            //On the other hand, the next button should now exist
            XCTAssertTrue(nextButton.waitForExistence(timeout: 5))
        }else{
            throw CustomError.custom("Audio not found")
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
