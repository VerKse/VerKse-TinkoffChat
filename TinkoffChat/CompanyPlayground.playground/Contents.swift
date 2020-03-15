import UIKit

class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class CEO: Person {
    var productManager: ProductManager?
    
    lazy var printManager = { [weak self] in
        print("\(self?.name ?? "ceo"):")
        print("\tMy Product Manager is \(self?.productManager?.name ?? "not appointed now")")
    }
    
    lazy var askManagerPrintDevelopers = { [weak self] in
        print("\(self?.name ?? "ceo"):")
        print("\t\(self?.productManager?.name ?? "Dear Product Manager"), print our developers, please.")
        self?.productManager?.printDevelopers()
    }
    
    lazy var askManagerPrintCompany = { [weak self] in
        print("\(self?.name ?? "ceo"):")
        print("\t\(self?.productManager?.name ?? "Dear Product Manager"), print all company, please.")
        self?.productManager?.printCompany()
    }

    init(name: String, productManager: ProductManager? = nil) {
        super.init(name: name)
        self.productManager = productManager
    }
    
    deinit {
        print("CEO \(self.name) deint")
    }
}

class ProductManager: Person {
    weak var ceo: CEO?
   // var developers: Developer[]?
    var developer1: Developer?
    var developer2: Developer?
    
    func printDevelopers(){
        print("\(self.name): ")
        /*if (developer1 == nil && developer2 == nil){
            print("\tWe haven't got any developers")
        } else {
            if (developer1 != nil){
                print("\tDeveloper: \(developer1?.name ?? "developer")")
            }
            if (developer2 != nil){
                print("\tDeveloper: \(developer2?.name ?? "developer")")
            }
        }

        if (developers != nil) {
            for dev in developers
            print ("Developer: \()")
        }*/
    }
    
    func printCompany(){
        print("\(self.name): ")
        print ("\tThe CEO: \(self.ceo?.name ?? "CEO")")
        print ("\tThe product manager: \(self.name)")
        if (developer1 == nil && developer2 == nil){
            print("\tWe haven't got any developers")
        } else {
            if (developer1 != nil){
                print("\tDeveloper: \(developer1?.name ?? "developer")")
            }
            if (developer2 != nil){
                print("\tDeveloper: \(developer2?.name ?? "developer")")
            }
        }
    }
    
    init(name: String,
         ceo: CEO? = nil,
         developer1: Developer? = nil,
         developer2: Developer? = nil){
        super.init(name: name)
        self.ceo = ceo
        self.developer1 = developer1
        self.developer2 = developer2
    }
    
    deinit {
        print("ProductManager \(self.name) deint")
    }
}

class Developer: Person{
    weak var productManager: ProductManager?
    
    func sayToAnotherDeveloper(message: String) {
        print( "\(self.name):")
        let developer =  {() -> Developer? in
            if (self.productManager?.developer1?.IsEqual(dev: self) ?? false) {
                return self.productManager?.developer2
            } else { return self.productManager?.developer1}
        }
        print("\tHey, \(developer()?.name ?? "developer")! \(message)")
    }
    
    func IsEqual (dev: Developer) -> Bool{
        if (self.name == dev.name) { return true }
        return false
    }
    
    func askMeneger(message: String) {
        print( "\(self.name):")
        print("\tHey, \(self.productManager?.name ?? "productManeger")! \(message)")
    }
    
    func askCEO(message: String) {
        print( "\(self.name):")
        print("\tHey, \(self.productManager?.ceo?.name ?? "CEO")! \(message)")
    }
    
    init(name: String, productManager: ProductManager? = nil){
        super.init(name: name)
        self.productManager = productManager
    }
    
    deinit {
        print("Developer \(self.name) deint")
    }
    
    class Messages {
        let notReallyGood = "До тебя тут работал Серёжа, так его за это уволили."
        let pullReqDone = "Я отправил тебе pull-request"
        let askAboutTask = "Дай мне новую задачу"
        let askAboutSalary = "Хочу зарплату побольше"
    }
}

class Company {
    
    var name: String
    var ceo: CEO
    var productManager: ProductManager
    var developer1: Developer
    var developer2: Developer
    var devMessages: Developer.Messages
    
    init(name: String,
         ceo: CEO,
         productManager:ProductManager,
         developer1: Developer,
         developer2: Developer) {
        
        self.name = name
        self.ceo = ceo
        self.productManager = productManager
        self.developer1 = developer1
        self.developer2 = developer2
        self.devMessages = Developer.Messages()
        
        self.ceo.productManager = self.productManager
        self.productManager.ceo = self.ceo
        self.productManager.developer1 = self.developer1
        self.developer1.productManager = self.productManager
        self.productManager.developer2 = self.developer2
        self.developer2.productManager = self.productManager
    }
    
}


func conversation(company: Company){
    company.ceo.printManager()
    company.ceo.askManagerPrintCompany()
    company.ceo.askManagerPrintDevelopers()
    company.developer1.sayToAnotherDeveloper(message: company.devMessages.pullReqDone)
    company.developer2.sayToAnotherDeveloper(message: "Ок, сейчас гляну")
    company.developer2.sayToAnotherDeveloper(message: company.devMessages.notReallyGood)
    company.developer1.askMeneger(message: company.devMessages.askAboutTask)
    company.developer2.askCEO(message: company.devMessages.askAboutSalary)
    print("-------end if conversation-------")
    print()
}

conversation(company: Company(
    name: "The Chillers",
    ceo: CEO(name: "Thomas"),
    productManager: ProductManager(name: "Polly"),
    developer1: Developer(name: "Arthur"),
    developer2: Developer(name: "John"))
)

