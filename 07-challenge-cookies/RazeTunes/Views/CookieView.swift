/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

// MARK: Cookie View

struct CookieView: View {
  // MARK: Properties

  @State private var description: String?

  // MARK: Body

  var body: some View {
    VStack {
      Image(systemName: "mouth")
        .resizable()
        .frame(maxWidth: 120, maxHeight: 70)
        .padding(.bottom, 20)

      Text("\(description ?? "-")")
        .padding(20)

      Button("Get Cookies") {
        Task {
          await getCookiesTapped()
        }
      }
    }
  }

  // MARK: Functions

  private func getCookiesTapped() async {
    func setDescription(for cookies: [HTTPCookie]? = nil) {
      Task { @MainActor in
        guard let cookies = cookies else {
          description = "Cookies: N/A"

          return
        }

        var descriptionString = ""

        for cookie in cookies {
          descriptionString += "\(cookie.name): \(cookie.value)"
        }

        description = descriptionString
      }
    }

    // TODO: Challenge - Print Cookies From A Request

    guard let url = URL(string: "https://google.com") else {
      setDescription()

      return
    }

    do {
      let (_, response) = try await URLSession.shared.data(from: url)

      guard let httpResponse = response as? HTTPURLResponse,
            let fields = httpResponse.allHeaderFields as? [String: String]
      else {
        setDescription()

        return
      }

      let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)

      setDescription(for: cookies)
    } catch {
      setDescription()
    }
  }
}

// MARK: - Preview Provider

struct CookieView_Previews: PreviewProvider {
  // MARK: Previews

  static var previews: some View {
    CookieView()
  }
}
