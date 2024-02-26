import Foundation


// MARK: - Structural Design Patterns

// MARK: - 1. Adapter Factory ========================================================

//Implementation
enum Weather: String{
    case sunny, rainy
}

protocol WeatherService{
    func getCurrentWeather() -> String
}

class WeatherProvider{
    func fetchWeatherData() -> Weather{
        return .sunny
    }
}

class weatherProviderAdapter: WeatherService{
    
    private let weatherProvider: WeatherProvider
    
    init(weatherProvider: WeatherProvider){
        self.weatherProvider = weatherProvider
    }
    func getCurrentWeather() -> String {
        let weather = weatherProvider.fetchWeatherData()
        return weather.rawValue.capitalized
    }
}
// Usage ------------------
//let weatherProvider = WeatherProvider()
//let providerService = weatherProviderAdapter(weatherProvider: weatherProvider)
//providerService.getCurrentWeather()

// MARK: - 2.Proxy (Protection Proxy)  ========================================================

//EX1:--------------
protocol SMSService{
    func sendSMS(custId: String, mobile: String, sms: String)
}
class SMSManager: SMSService{
    func sendSMS(custId: String, mobile: String, sms: String) {
        print("the user with id:\(custId) send msg:\(sms) to mobile:\(mobile) ")
    }
}
class SMSManagerProxy{
    
    lazy var smsService: SMSService = SMSManager()
    var sentCount = [String: Int]()
    
    func sendSMS(custId: String, mobile: String, sms: String) {
        if !sentCount.keys.contains(custId) {
            sentCount[custId] = 1
            smsService.sendSMS(custId: custId, mobile: mobile, sms: sms)
        }else{
            guard var customerValue = sentCount[custId] else{
                return
            }
            if customerValue >= 3 {
                print("Can't Send!")
            }else{
                customerValue =  customerValue + 1
                sentCount[custId] = customerValue
                smsService.sendSMS(custId: custId, mobile: mobile, sms: sms)
            }
            
        }
    }
}
//var smsProxy = SMSManagerProxy()
//smsProxy.sendSMS(custId: "123", mobile: "0112233", sms: "message 01")
//smsProxy.sendSMS(custId: "123", mobile: "0112233", sms: "message 02")
//smsProxy.sendSMS(custId: "123", mobile: "0112233", sms: "message 03")
//smsProxy.sendSMS(custId: "123", mobile: "0112233", sms: "message 03")
//


//EX2:--------------
//Implementation
protocol DoorOpening{
    func open(doors: String) -> String
}
class DoorService: DoorOpening{
    func open(doors: String) -> String {
        return "Doors that opening are \(doors) doors "
    }
    
}
class DoorServiceProxy{
    private var computer: DoorService!
    func authenticate(password: String) -> Bool{
        guard password == "pass" else{
            return false
        }
        computer = DoorService()
        return true
    }
    func open(doors: String) -> String{
        guard computer != nil else{
            return "Access Denied"
        }
        return computer.open(doors: doors)
    }
}

//Usage ------------------
//let computer = DoorServiceProxy()
//let door = "4"
//
//computer.open(doors: door)
//
//computer.authenticate(password: "pass")
//computer.open(doors: door)

// MARK: - 3.Adapter ========================================================

//Implementation
struct OldStarTarget{
    let angleHorizontal: Float
    let angleVertical: Float
    
    init(angleHorizontal: Float, angleVertical: Float) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
struct NewStarTarget{
    private let targert: OldStarTarget
    
    var angleV: Int{
        return Int(targert.angleVertical)
    }
    var angleH: Int{
        return Int(targert.angleHorizontal)
    }
    
    init(_ target: OldStarTarget) {
        self.targert = target
    }
    
}
//Usage ------------------
//let target = OldStarTarget(angleHorizontal: 10.5, angleVertical: 14.434)
//let newFormat = NewStarTarget(target)
//
//newFormat.angleH
//newFormat.angleV

// MARK: - 4.Decorator (Wrapper) ========================================================

//Implementation

//class Pizza{
//    let description: String = "Simple Pizza"
//    let cost: Int = 50
//
//    func getDescription() -> String{
//        return self.description
//    }
//    func getCost() -> Int{
//        return self.cost
//    }
//}

protocol DataHaving{
    var ingredient: [String] { get }
    var cost: Double { get }
}

struct Pizza: DataHaving{
    var ingredient = ["Simple Pizza"]
    var cost: Double = 50
}

protocol ComponentDecorator: DataHaving{
    var component: DataHaving { get }
}

struct Chesse: ComponentDecorator{
    var component: DataHaving
    
    var ingredient: [String] {
        return component.ingredient + ["Chesse"]
    }
    
    var cost: Double{
        return component.cost + 10
    }
      
}

struct Cheichen: ComponentDecorator{
    var component: DataHaving
    
    var ingredient: [String] {
        return component.ingredient + ["Cheichen"]
    }
    
    var cost: Double{
        return component.cost + 20
    }
      
}

struct Mozzarell: ComponentDecorator{
    var component: DataHaving
    
    var ingredient: [String] {
        return component.ingredient + ["Mozzarell"]
    }
    
    var cost: Double{
        return component.cost + 5
    }
      
}

//Usage ------------------
//var pizza: DataHaving = Pizza()
//pizza.cost
//pizza.ingredient
//
//pizza = Mozzarell(component: pizza)
//pizza.cost
//pizza.ingredient
//
//pizza = Cheichen(component: pizza)
//pizza.cost
//pizza.ingredient

// MARK: - 5.Facade  ========================================================

//Implementation
class Defaults{
    private let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    subscript(key: String) -> String? {
        get{
            return defaults.string(forKey: key)
        }
        set{
            defaults.set(newValue, forKey: key)
        }
    }
    
}

//Usage ------------------
//let storage = Defaults()
//storage["myName"] = "Youssef Eldeeb"
//storage["myName"]



// MARK: - Interview Question in Awmmer Alshabaka

protocol ServiceDelegate {
    func makeAction()
}
class Controller1: ServiceDelegate{
    
    lazy var controller2 = Controller2(delegate: self)
    
    func makeAction() {
//        var controller2 = Controller2(delegate: self)
        print("action")
        controller2.makeAny()
    }
}

class Controller2 {
    let delegate: ServiceDelegate
    init(delegate: ServiceDelegate) {
        self.delegate = delegate
    }
    func makeAny(){
        print("dkfjklaj")
    }
}


