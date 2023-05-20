import Foundation

//Creational Design Patterns

// MARK: - 1. Singleton

//Implementation
class Singleton {
    static let shared = Singleton()
    private init() {}

    func printingFunction() {
        print("Hello, I'm a singleton, and this is how to use me to call other functions inside me")
    }
}

//Using

//Singleton.shared.printingFunction()

// MARK: - 2. Prototype

//Implementation

class MoonWorker {

    var name: String
    var health: Int = 100

    init(name: String) {
        self.name = name
    }

    func clone() -> MoonWorker {
        return MoonWorker(name: name)
    }
}

//Using

//let prototype = MoonWorker(name: "Sam Bell")
//let proto1 = prototype.clone()
//proto1
//let proto2 = prototype.clone()
//proto2.name = "Ahmed"
//proto2

// MARK: - 3. Builder

//Implementation
final class DeathStarBuilder {
    var x: Double?
    var y: Double?
    var z: Double?

    typealias BuilderClosure = (DeathStarBuilder) -> ()

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar : CustomStringConvertible {
    let x: Double
    let y: Double
    let z: Double

    init?(builder: DeathStarBuilder) {
        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }

    var description:String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}

//Usage

//let empire = DeathStarBuilder { builder in
//    builder.x = 0.1
//    builder.y = 0.2
//    builder.z = 0.3
//}
//let deathStar = DeathStar(builder:empire)
//deathStar?.description

// MARK: - 4. Factory Method

//Implementation
protocol CurrencyDescribing {
    var symbol: String { get }
    var code: String { get }
}

final class Euro: CurrencyDescribing {
    var symbol: String {
        return "€"
    }
    var code: String {
        return "EUR"
    }
}

final class UnitedStatesDolar: CurrencyDescribing {
    var symbol: String {
        return "$"
    }
    var code: String {
        return "USD"
    }
}

enum Country {
    case unitedStates
    case spain
    case uk
    case greece
}

enum CurrencyFactory {
    static func currency(for country: Country) -> CurrencyDescribing? {

        switch country {
            case .spain, .greece:
                return Euro()
            case .unitedStates:
                return UnitedStatesDolar()
            default:
                return nil
        }
    }
}

//Usage

//let noCurrencyCode = "No Currency Code Available"
//
//CurrencyFactory.currency(for: .greece)?.code ?? noCurrencyCode
//CurrencyFactory.currency(for: .spain)?.code ?? noCurrencyCode
//CurrencyFactory.currency(for: .unitedStates)?.code ?? noCurrencyCode
//CurrencyFactory.currency(for: .uk)?.code ?? noCurrencyCode

// MARK: - 5. Abstract Factory

//Implementation
protocol BurgerDescribing {
    var ingredients: [String] { get }
}

struct CheeseBurger: BurgerDescribing {
    let ingredients: [String]
}
struct ChickenBurger: BurgerDescribing{
    var ingredients: [String]
}

protocol BurgerMaking {
    func make() -> BurgerDescribing
}

// Number implementations with factory methods
final class BigKahunaBurger: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Lettuce", "Tomato"])
    }
}
final class JackInTheBox: BurgerMaking {
    func make() -> BurgerDescribing {
        return CheeseBurger(ingredients: ["Cheese", "Burger", "Tomato", "Onions"])
    }
}
final class KFCBurger: BurgerMaking{
    func make() -> BurgerDescribing {
        return ChickenBurger(ingredients: ["chicken", "Burger", "Tomato", "Onions"])
    }
}

enum BurgerFactoryType: BurgerMaking {

    case bigKahuna
    case jackInTheBox
    case KFC_Burger

    func make() -> BurgerDescribing {
        switch self {
        case .bigKahuna:
            return BigKahunaBurger().make()
        case .jackInTheBox:
            return JackInTheBox().make()
        case .KFC_Burger:
            return KFCBurger().make()
        }
    }
}

//Usage

BurgerFactoryType.bigKahuna.make()
BurgerFactoryType.jackInTheBox.make()
BurgerFactoryType.KFC_Burger.make()
