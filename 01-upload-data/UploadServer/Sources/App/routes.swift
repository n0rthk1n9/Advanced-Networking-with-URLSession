import Fluent
import Vapor

struct MusicItemRating: Content {
    let id: String
    let artistName: String
    let trackName: String
    let rating: Int
}

func routes(_ app: Application) throws {
    app.get { _ async in
        "It works!"
    }

    app.get("hello") { _ async -> String in
        "Hello, world!"
    }

    app.post("upload") { req -> HTTPResponseStatus in
        let item = try req.content.decode(MusicItemRating.self)

        print("ID: \(item.id)")
        print("Artist Name: \(item.artistName)")
        print("Track Name: \(item.trackName)")
        print("Rating: \(item.rating)")

        return .ok
    }

    try app.register(collection: TodoController())
}
