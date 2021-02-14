// Copyright 2021 Tokamak contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import OpenCombine
import TokamakTestRenderer
import XCTest

@testable import TokamakCore

private struct SpookyHanger: App {
  var body: some Scene {
    WindowGroup("Spooky Hanger") {
      NavigationView {
        List {
          ForEach(["Item 1"], id: \.self) { childRow in
            NavigationLink(
              destination: Text(childRow)
            ) {
              Text(childRow)
            }
          }
        }
      }
    }
  }

  static func _setTitle(_ title: String) {}

  /// Implemented by the renderer to mount the `App`
  static func _launch(_ app: Self, _ rootEnvironment: EnvironmentValues) {}

  /// Implemented by the renderer to update the `App` on `ScenePhase` changes
  var _phasePublisher: AnyPublisher<ScenePhase, Never> { Empty().eraseToAnyPublisher() }

  /// Implemented by the renderer to update the `App` on `ColorScheme` changes
  var _colorSchemePublisher: AnyPublisher<ColorScheme, Never> { Empty().eraseToAnyPublisher() }
}

final class ReconcilerStressTests: XCTestCase {
  func testSpookyHanger() {
    let renderer = TestRenderer(SpookyHanger())
    let root = renderer.rootTarget

    return

    let list = root.subviews[0].subviews[0]

    XCTAssertTrue(
      root.view
        .view is NavigationView<List<Never, ForEach<[String], String, NavigationLink<Text, Text>>>>
    )

    guard let link = list.subviews[0].view.view as? NavigationLink<Text, Text> else {
      XCTAssert(false, "navigation has no link")
      return
    }

    _NavigationLinkProxy(link).activate()
  }
}