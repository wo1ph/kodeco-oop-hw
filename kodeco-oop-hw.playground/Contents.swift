// Exercise 1
class Post {
    var author: String
    var content: String
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
}

// Exercise 2
class Product {
    var name: String
    var price: Double
    var quantity: Int
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

class ShoppingCartSingleton {
    private static var shoppingCartInstance: ShoppingCartSingleton?
    
    private var products: [Product] = []
    
    private init() {}
    
    static func sharedInstance() -> ShoppingCartSingleton {
        if shoppingCartInstance == nil {
            shoppingCartInstance = ShoppingCartSingleton()
        }
        
        return shoppingCartInstance!
    }
    
    func addProduct(product: Product, quantity: Int) {
        if let existingProduct = products.first(where: { $0.name == product.name }) {
            existingProduct.quantity += quantity
        } else {
            let newProduct = Product(name: product.name, price: product.price, quantity: quantity)
            products.append(newProduct)
        }
    }
    
    func removeProduct(product: Product) {
        products.removeAll { $0.name == product.name }
    }
    
    func clearCart() {
        products.removeAll()
    }
    
    func getTotalPrice() -> Double {
        var total = 0.0
        for product in products {
            total += product.price * Double(product.quantity)
        }
        return total
    }
}

// Exercise 3
enum PaymentError: Error {
    case insufficientFunds
    case connectionError
    case invalidCard
    
    var message: String {
        switch self {
        case .insufficientFunds:
            return "Insufficient Funds."
        case .connectionError:
            return "Connection Failed."
        case .invalidCard:
            return "Invalid card number."
        }
    }
}

protocol PaymentProcessor {
    func processPayment(amount: Double) throws
}

class CreditCardProcessor: PaymentProcessor {
    var availableBalance: Double
    var cardNumber: String
    
    init(balance: Double, cardNumber: String) {
        self.availableBalance = balance
        self.cardNumber = cardNumber
    }
    
    private func validateCard() -> Bool {
        cardNumber.count == 16
    }
    
    func processPayment(amount: Double) throws {
        if availableBalance < amount {
            throw PaymentError.insufficientFunds
        } else if !validateCard() {
            throw PaymentError.invalidCard
        } else {
            availableBalance -= amount
            print("Your credit card payment of $\(amount) was successful.")
        }
    }
}

class AppleCashProcessor: PaymentProcessor {
    var walletBalance: Double?
    
    init(balance: Double?) {
        self.walletBalance = balance
    }
    
    func processPayment(amount: Double) throws {
        guard let balance = walletBalance else {
            throw PaymentError.connectionError
        }
        
        if balance < amount {
            throw PaymentError.insufficientFunds
        } else {
            walletBalance = balance - amount
            print("Your payment of $\(amount) was approved. Remaining Apple Cash: $\(walletBalance!)")
        }
    }
}

func main() {
    //Exercise 1
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
    
    //Exercise 3
    var creditCardProcessor = CreditCardProcessor(balance: 200.0, cardNumber: "4444444444444444")
    
    do {
        try creditCardProcessor.processPayment(amount: 50.0)
    } catch let error as PaymentError {
        print("Credit card payment failed: \(error.message)")
    } catch {
        print("Credit card payment failed. Please try again.")
    }
    
    do {
        try creditCardProcessor.processPayment(amount: 170.0)
    } catch let error as PaymentError {
        print("Credit card payment failed: \(error.message)")
    } catch {
        print("Credit card payment failed. Please try again.")
    }
    
    creditCardProcessor = CreditCardProcessor(balance: 200.0, cardNumber: "4444")
    
    do {
        try creditCardProcessor.processPayment(amount: 170.0)
    } catch let error as PaymentError {
        print("Credit card payment failed: \(error.message)")
    } catch {
        print("Credit card payment failed. Please try again.")
    }
    
    var appleCashProcessor = AppleCashProcessor(balance: 150.0)
    
    do {
        try appleCashProcessor.processPayment(amount: 120.0)
    } catch let error as PaymentError {
        print("Apple cash payment failed: \(error.message)")
    } catch {
        print("Apple cash payment failed. Please try again.")
    }
    
    do {
        try appleCashProcessor.processPayment(amount: 40.0)
    } catch let error as PaymentError {
        print("Apple cash payment failed: \(error.message)")
    } catch {
        print("Apple cash payment failed. Please try again.")
    }
    
    appleCashProcessor = AppleCashProcessor(balance: nil)
    
    do {
        try appleCashProcessor.processPayment(amount: 50.0)
    } catch let error as PaymentError {
        print("Apple cash payment failed: \(error.message)")
    } catch {
        print("Apple cash payment failed. Please try again.")
    }
}

main()
