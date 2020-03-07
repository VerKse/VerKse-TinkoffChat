import UIKit


    class CEO {
        var name: String
        var productManager: ProductManager?
        
        let printManager = { (ceo: CEO) -> Void in
            print("\(ceo.name):")
            print("\tMy Product Manager is \(ceo.productManager?.name ?? "not appointed now")")
        }
        
        let askManagerPrintDevelopers = { (ceo: CEO) -> Void in
            print("\(ceo.name):")
            print("\t\(ceo.productManager?.name ?? "Dear Product Manager"), print our developers, please.")
            ceo.productManager?.printDevelopers()
        }
        
        let askManagerPrintCompany = { (ceo: CEO) -> Void in
            print("\(ceo.name):")
            print("\t\(ceo.productManager?.name ?? "Dear Product Manager"), print all company, please.")
            ceo.productManager?.printCompany()
        }
        
        
        init(name: String, productManager: ProductManager? = nil) {
            self.name = name
            self.productManager = productManager
        }
        
        deinit {
            print("CEO \(self.name) deint")
        }
    }
    
    class ProductManager {
        var name: String
        weak var ceo: CEO?
        var developer1: Developer?
        var developer2: Developer?
        
        func printDevelopers(){
            print("\(self.name): ")
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
        
        init(name: String, ceo: CEO? = nil,
             developer1: Developer? = nil, developer2: Developer? = nil){
            self.name = name
            self.ceo = ceo
            self.developer1 = developer1
            self.developer2 = developer2
        }
        
        deinit {
            print("ProductManager \(self.name) deint")
        }
    }
    
    class Developer{
        var name: String
        weak var productManager: ProductManager?
        
        func sayToAnotherDeveloper(message: String) {
            print( "\(self.name):")
            let developer =  {() -> Developer? in
                if (self.productManager?.developer2?.IsEqual(dev2: self) ?? false) {
                    return self.productManager?.developer1
                } else { return self.productManager?.developer2}
            }
            print("\tHey, \(developer()?.name ?? "developer")! \(message)")
        }
        
        func IsEqual (dev2: Developer) -> Bool{
            if (self.name == dev2.name) { return true }
            return true
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
            self.name = name
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
         ceo: CEO?,
         productManager:ProductManager?,
         developer1: Developer?,
         developer2: Developer?) {
    
        self.name = name
        self.ceo = ceo ?? CEO(name: "default ceo")
        self.productManager = productManager ?? ProductManager(name: "deault productManager")
        self.developer1 = developer1 ?? Developer(name: "default developer1")
        self.developer2 = developer2 ?? Developer(name: "deafault developer2")
        self.devMessages = Developer.Messages()
        
        self.ceo.productManager = self.productManager
        self.productManager.ceo = self.ceo
        self.productManager.developer1 = self.developer1
        self.developer1.productManager = self.productManager
        self.productManager.developer2 = self.developer2
        self.developer2.productManager = self.productManager
    }
    
    
    func conversation(){
        self.ceo.askManagerPrintCompany(ceo)
        
        self.developer2.sayToAnotherDeveloper(message: devMessages.notReallyGood)
        self.developer1.askMeneger(message: devMessages.askAboutTask)
        self.developer2.askCEO(message: devMessages.askAboutSalary)
        
        self.ceo.printManager(ceo)
        self.ceo.askManagerPrintDevelopers(ceo)
        self.ceo.askManagerPrintCompany(ceo)

        print("-------end if conversation-------")
        print()
    }
}

var chiller: Company? = Company(
    name: "The Chillers",
    ceo: CEO(name: "Thomas"),
    productManager: ProductManager(name: "Polly"),
    developer1: Developer(name: "Arthur"),
    developer2: Developer(name: "John"))
chiller?.conversation()

chiller?.developer2 = Developer(name: "Mikle")
chiller?.productManager.developer2 = chiller?.developer2
chiller?.productManager.printCompany()

chiller = nil


