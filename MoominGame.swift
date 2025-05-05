import Foundation


enum CreatureType {
    case friendly
    case curious
    case mysterious
}

struct Item {
    var name: String
    var healthRestoration: Int
}


struct MoominCharacter {
    var name: String
    var health: Int
    var friendship: Int
    var level: Int
    var experience: Int
    
    var isHealthy: Bool {
        return health > 0
    }
    
    mutating func levelUp() {
        if experience >= 100 { 
            level += 1
            health += 10
            friendship += 5
            experience = 0 
            print("\(name) zdobył nowy poziom! Poziom: \(level), Zdrowie: \(health), Przyjaźń: \(friendship)")
        }
    }
    
    func displayStats() {
        print("Statystyki \(name): Poziom: \(level), Zdrowie: \(health), Przyjaźń: \(friendship), Doświadczenie: \(experience)")
    }
}


struct Creature {
    var name: String
    var mood: Int
    var patience: Int
    var type: CreatureType
    
    var isCalm: Bool {
        return patience > 0
    }
    
    static func randomEncounter() -> Creature {
        let creatures = [
            Creature(name: "The Groke", mood: Int.random(in: 1...3), patience: 20, type: .mysterious),
            Creature(name: "Hattifattener", mood: Int.random(in: 1...3), patience: 15, type: .curious),
            Creature(name: "Stinky", mood: Int.random(in: 1...3), patience: 10, type: .friendly)
        ]
        return creatures.randomElement()!
    }
}

var journal: [String] = []
var items: [Item] = [
    Item(name: "Hot Cocoa", healthRestoration: 20),
    Item(name: "Map", healthRestoration: 0) 
]

func exploreAndInteract(moomin: inout MoominCharacter) {
    while moomin.isHealthy {
        var creature = Creature.randomEncounter()
        print("Spotkanie z: \(creature.name), Nastrój: \(creature.mood), Cierpliwość: \(creature.patience)")
        
        moomin.displayStats()
        
        print("Wybierz akcję: 1 - Rozmawiaj, 2 - Uciekaj, 3 - Użyj przedmiotu")
        if let input = readLine(), let choice = Int(input) {
            switch choice {
            case 1:
                talkToCreature(&moomin, creature: &creature)
            case 2:
                if runAway() {
                    print("Moomin uciekł bezpiecznie!")
                } else {
                    print("Moomin nie zdążył uciec i został przestraszony!")
                    moomin.health -= 5
                    print("Moomin stracił 5 zdrowia. Aktualne zdrowie: \(moomin.health)")
                }
            case 3:
                useItem(&moomin)
            default:
                print("Nieprawidłowy wybór.")
            }
            
            if !creature.isCalm {
                print("\(creature.name) jest nadal w złym nastroju!")
                moomin.health -= 10
                print("Moomin stracił 10 zdrowia. Aktualne zdrowie: \(moomin.health)")
            }
            
            if !moomin.isHealthy {
                print("Moomin stracił wszystkie punkty zdrowia! Gra się kończy.")
                break
            }
        }
    }
}

func talkToCreature(_ moomin: inout MoominCharacter, creature: inout Creature) {
    creature.patience -= moomin.friendship
    print("\(moomin.name) rozmawia z \(creature.name). Cierpliwość stworzenia spadła do \(creature.patience).")
    
   
    if creature.isCalm {
        moomin.experience += 50 
        print("\(moomin.name) zdobył 50 punktów doświadczenia!")
        moomin.levelUp() 
    }
}

func runAway() -> Bool {
    return Bool.random()
}

func useItem(_ moomin: inout MoominCharacter) {
    print("Wybierz przedmiot do użycia:")
    for (index, item) in items.enumerated() {
        print("\(index + 1) - \(item.name) (Przywraca \(item.healthRestoration) zdrowia)")
    }
    
    if let input = readLine(), let choice = Int(input), choice > 0, choice <= items.count {
        let selectedItem = items[choice - 1]
        moomin.health += selectedItem.healthRestoration
        print("\(moomin.name) użył \(selectedItem.name) i przywrócił \(selectedItem.healthRestoration) zdrowia.")
        
        
        if moomin.health > 100 {
            moomin.health = 100
        }
        
        print("Aktualne zdrowie \(moomin.name): \(moomin.health)")
    } else {
        print("Nieprawidłowy wybór przedmiotu.")
    }
}

func handleEncounter(moomin: inout MoominCharacter) {
    let creature = Creature.randomEncounter()
    journal.append("Spotkanie z: \(creature.name)")
    exploreAndInteract(moomin: &moomin)
}

func startGame() {
    var moomin = MoominCharacter(name: "Moomintroll", health: 100, friendship: 10, level: 1, experience: 0)
    print("Witaj w Dolinie Muminków, \(moomin.name)!")
    
    while moomin.isHealthy {
        handleEncounter(moomin: &moomin)
    }
    
    
    print("Dziennik Moomina:")
    for entry in journal {
        print(entry)
    }
}

startGame()

