import Vapor

func routes(_ app: Application) throws {
    app.webSocket("chat") { _, ws in
        ws.send("Connected")

        ws.onText { ws, text in
            ws.send("Text Received: \(text)")

            print("Received from client: \(text)")
        }

        ws.onClose.whenComplete { result in
            switch result {
            case .success():
                print("Closed")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
