// Exercise 1

class Post {
    let author: String
    let content: String
    var likes = 0
    
    init(author: String, content: String) {
        self.author = author
        self.content = content
    }
    
    func display() {
        print("Post from \(author) with \(likes) likes: \(content)")
    }
    
    func incrementLikes() {
        likes += 1
    }
    
    func decrementLikes() {
        if likes > 0 {
            likes -= 1
        } else {
            likes = 0
        }
    }
}

let nbaPost = Post(author: "@NBA", content: "LeBron James has won his 5th NBA championship ring.")
for _ in 0..<100 {
    nbaPost.incrementLikes()
}
nbaPost.display()
let applePost = Post(author: "@TimCook", content: "We are pleased to announce the next device in our Vision product family: Vision Air.")
for _ in 0..<50 {
    applePost.incrementLikes()
}
applePost.display()
