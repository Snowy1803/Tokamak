// Copyright 2020 Tokamak contributors
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
//
//  Created by Carson Katri on 7/20/20.
//

import JavaScriptKit
import OpenCombine
import TokamakCore

public class LocalStorage: WebStorage, _StorageProvider {
  let storage = JSObjectRef.global.localStorage.object!

  required init() {
    _ = JSObjectRef.global.window.object!.addEventListener!("storage", JSClosure { _ in
      self.publisher.send()
      return .undefined
    })
    subscription = Self.rootPublisher.sink { _ in
      self.publisher.send()
    }
  }

  public static var standard: _StorageProvider {
    Self()
  }

  var subscription: AnyCancellable?
  static let rootPublisher = ObservableObjectPublisher()
  public let publisher = ObservableObjectPublisher()
}
