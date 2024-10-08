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
/*
شبة بوابة للابجكت
 بيخليك تقدر تغير سلوك معين عن طريق كلاس وسيط ومش بتقدر توصل للماين كلاس
 
*/

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
            if customerValue >= 3{
                print("Can't Send!")
            }else{
                customerValue =  customerValue + 1
                sentCount[custId] = customerValue
                smsService.sendSMS(custId: custId, mobile: mobile, sms: sms)
            }
            
        }
    }
}
var smsProxy = SMSManagerProxy()
smsProxy.sendSMS(custId: "123", mobile: "011", sms: "message 01")
smsProxy.sendSMS(custId: "123", mobile: "022", sms: "message 02")
smsProxy.sendSMS(custId: "123", mobile: "033", sms: "message 03")
smsProxy.sendSMS(custId: "123", mobile: "044", sms: "message 04")



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
 /*
  used to dynamically add behavior or functionality to objects without altering their structure
  - (Open/Close) principle
   هنا انا براعي مبدأ الأبن كلوس وهحل مشكله اني لو عايز اضيف حاجه جديده من غير ما اعدل في القديم
  
  */
//Implementation

//EX1:--------------
// 1. Component (Protocol)
protocol Coffee {
    func cost() -> Double
    func ingredients() -> String
}

// 2. ConcreteComponent (Base Object)
class SimpleCoffee: Coffee {
    func cost() -> Double {
        return 2.0
    }
    
    func ingredients() -> String {
        return "Coffee"
    }
}

// 3. Decorator (Abstract Class)
class CoffeeDecorator: Coffee {
    private let decoratedCoffee: Coffee
    
    init(decoratedCoffee: Coffee) {
        self.decoratedCoffee = decoratedCoffee
    }
    
    func cost() -> Double {
        return decoratedCoffee.cost()
    }
    
    func ingredients() -> String {
        return decoratedCoffee.ingredients()
    }
}

// 4. Concrete Decorators
class MilkDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 0.5
    }
    
    override func ingredients() -> String {
        return super.ingredients() + ", Milk"
    }
}

class SugarDecorator: CoffeeDecorator {
    override func cost() -> Double {
        return super.cost() + 0.2
    }
    
    override func ingredients() -> String {
        return super.ingredients() + ", Sugar"
    }
}

// Usage
var myCoffee: Coffee = SimpleCoffee()
print("Cost: \(myCoffee.cost()), Ingredients: \(myCoffee.ingredients())")

myCoffee = MilkDecorator(decoratedCoffee: myCoffee)
print("Cost: \(myCoffee.cost()), Ingredients: \(myCoffee.ingredients())")

myCoffee = SugarDecorator(decoratedCoffee: myCoffee)
print("Cost: \(myCoffee.cost()), Ingredients: \(myCoffee.ingredients())")



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
//EX2:--------------
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


//EX3:--------------
class ConcreteSMSService: SMSService{
    func sendSMS(custId: String, mobile: String, sms: String) {
        print("this \(sms) SMS is to \(custId) user with \(custId) phone")
    }
}

class AbstractDecorator: SMSService{
    private let decoratedSMS: SMSService
    
    init(decoratedSMS: SMSService) {
        self.decoratedSMS = decoratedSMS
    }
    
    func sendSMS(custId: String, mobile: String, sms: String) {
        decoratedSMS.sendSMS(custId: custId, mobile: mobile, sms: sms)
    }
}

//هنا التعديل ال عايز اضيفه من غير ما اعدل في الكلاس الاصلي
class NotificationEmailDecorator: AbstractDecorator{
    
    private func sendSMSNotification(custId: String, sms: String){
        print("\(sms) SMS is sent to \(custId)")
    }
    
    override func sendSMS(custId: String, mobile: String, sms: String) {
        super.sendSMS(custId: custId, mobile: mobile, sms: sms)
        sendSMSNotification(custId: custId, sms: sms)
    }
}

var mySMS: SMSService = ConcreteSMSService()
mySMS.sendSMS(custId: "123", mobile: "01156377094", sms: "hello")

var notificationSMS = NotificationEmailDecorator(decoratedSMS: mySMS)
notificationSMS.sendSMS(custId: "123", mobile: "01156377094", sms: "hello")

// MARK: - 5.Facade  ========================================================


// The facade pattern is used to define a simplified interface to a more complex subsystem.
/*
 بدل ما اعمل اكتر من اكشن مختلف في مكان ال هستخدمه فيه
لا هخلي فيه كلاس واحد وسيط بيعملي هو الاكشن ده وانا استخدم الكلاس الوسيط ده
 
 - مسؤل انه يجمع العمليات كلها الخاصه بحاجه معينه في مكان واحد
 مش بيتناقض مع مبدأ السنجل ريسبونسبلتي لاني هنا بعمل حاجه واحده بس ال هي اني بجمع العمليات كلها في مكان واحد
 
 - الفرق بينه وبين البروكسي ان البروكسي مش بتقدر توصل للمين كلاس الا عن طريق البروكسي كلاس
 فالبروكسي كدا بيحجب الابوجكت ال وراه
 
 البروكسي بيخليك تقدر تغير سلوك عمليه معينه بتحصل -زي موضوع الرسايل
 
*/

//EX1:--------------
//Implementation
class Projector {
    func turnOn() {
        print("Projector is on.")
    }
    
    func turnOff() {
        print("Projector is off.")
    }
}

class Speaker {
    func turnOn() {
        print("Speaker is on.")
    }
    
    func turnOff() {
        print("Speaker is off.")
    }
    
    func setVolume(level: Int) {
        print("Speaker volume set to \(level).")
    }
}

class BluRayPlayer {
    func turnOn() {
        print("Blu-ray player is on.")
    }
    
    func turnOff() {
        print("Blu-ray player is off.")
    }
    
    func playMovie(_ movie: String) {
        print("Playing movie: \(movie).")
    }
}


class HomeTheaterFacade {
    private let projector: Projector
    private let speaker: Speaker
    private let bluRayPlayer: BluRayPlayer
    
    init(projector: Projector, speaker: Speaker, bluRayPlayer: BluRayPlayer) {
        self.projector = projector
        self.speaker = speaker
        self.bluRayPlayer = bluRayPlayer
    }
    
    func watchMovie(_ movie: String) {
        print("Get ready to watch a movie...")
        projector.turnOn()
        speaker.turnOn()
        speaker.setVolume(level: 20)
        bluRayPlayer.turnOn()
        bluRayPlayer.playMovie(movie)
    }
    
    func endMovie() {
        print("Shutting down the home theater system...")
        projector.turnOff()
        speaker.turnOff()
        bluRayPlayer.turnOff()
    }
}

//Usage ------------------
let projector = Projector()
let speaker = Speaker()
let bluRayPlayer = BluRayPlayer()

let homeTheater = HomeTheaterFacade(projector: projector,
                                    speaker: speaker,
                                    bluRayPlayer: bluRayPlayer)

homeTheater.watchMovie("Inception")
// Output:
// Get ready to watch a movie...
// Projector is on.
// Speaker is on.
// Speaker volume set to 20.
// Blu-ray player is on.
// Playing movie: Inception.

homeTheater.endMovie()
// Output:
// Shutting down the home theater system...
// Projector is off.
// Speaker is off.
// Blu-ray player is off.




//EX2:--------------
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


