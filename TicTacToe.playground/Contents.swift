//tic tac toe
import Foundation
//MARK: - Enum
enum TypeOfFields: String {
    case empty = "⬜️"
    case cross = "❌"
    case tac = "⭕️"
}

struct TicTacToe {
    //MARK: - Variables
    private let row = 3
    private let column = 3
    private var turnCount = 1
    private var isStarted = false
    private var fields = [[TypeOfFields]]()
    private var botType: TypeOfFields{
        return chooseTacOrCross == .cross ? .tac : .cross
    }
    private var chooseTacOrCross: TypeOfFields
    
    //MARK: - Init
    init(chooseTacOrCross: TypeOfFields ) {
        self.chooseTacOrCross = chooseTacOrCross
    }
    
    //MARK: - private Function
    
    /// Заполнениие массива пустыми полями
    private mutating func fillInTheField() {
        for _ in 0..<column {
            var fieldsOfRow = [TypeOfFields]()
            for _ in 0..<row {
                fieldsOfRow.append(.empty)
            }
            fields.append(fieldsOfRow)
        }
    }
    
    /// Распечатка поля
    private func printField() {
        print("   0 1 2")
        for x in 0..<fields.count {
            var result = ""
            for y in 0..<fields[x].count {
                result += fields[y][x].rawValue
            }
            print("\(x) \(result)")
        }
        
    }
    /// Определение выигрыша
    private var isWin: Bool {
        return fields[0][0] == fields[0][1] && fields[0][0] == fields[0][2] && fields[0][0] != .empty ||
            fields[1][0] == fields[1][1] && fields[1][0] == fields[1][2] && fields[1][0] != .empty ||
            fields[2][0] == fields[2][1] && fields[2][0] == fields[2][2] && fields[2][0] != .empty ||
            fields[0][0] == fields[1][0] && fields[0][0] == fields[2][0] && fields[0][0] != .empty ||
            fields[0][1] == fields[1][1] && fields[0][1] == fields[2][1] && fields[0][1] != .empty ||
            fields[0][2] == fields[1][2] && fields[0][2] == fields[2][2] && fields[0][2] != .empty ||
            fields[0][0] == fields[1][1] && fields[0][0] == fields[2][2] && fields[0][0] != .empty ||
            fields[0][2] == fields[1][1] && fields[0][2] == fields[2][0] && fields[2][0] != .empty
    }
    
    /// Создание хода
    private mutating func turn(row: Int, column: Int, type: TypeOfFields) {
        ///Проверка, чтобы не выходили за поля 3х3
        guard !(column > fields.count - 1 || row > fields.count - 1) else {
            print("Wrong: Cell \(column) \(row) out of field")
            return
        }
        /// Проверяем наличие пустой клетки
        guard fields[column][row] == .empty else {
            print("Wrong: Cell \(column) \(row) already used")
            /// ДЛЯ БОТА - Если клетка занята, повторяет ход бота
            if type == botType {
                return botTurn()
            }
            return
        }
        /// Передаем тип энума
        fields[column][row] = type
        /// Консолим игру
        printField()
        /// Обновляем счетчик
        turnCount += 1
        /// Проверка на выигрыш
        if isWin {
            turnCount % 2 == 0 ? print("You won") : print("Bot won")
            return
        }
        /// Проверка на ничью
        if turnCount == 10 {
            print("Game over")
        }
        /// Разделяем принты
        print("==================")
    }
    
    /// Создание хода бота
    private mutating func  botTurn() {
        let row = Int.random(in: 0..<3)
        let column = Int.random(in: 0..<3)
        turn(row: row, column: column, type: botType)
    }
    
    //MARK: - Functionы for game
    
    /// Создание твоего хода
    mutating func yourTurn(_ row: Int, _ column: Int) {
        /// Проверка, на выбранный пустую ячейку
        guard chooseTacOrCross != .empty else { return }
        turn(row: row, column: column, type: chooseTacOrCross)
        /// Проверка на выйгрыш, чтобы после победы не начал ходить
        guard isWin == false else{ return }
        /// Проверка на свой ход, чтобы если вы сходили на одну и туже клетку, бот не начал ходить раньше вас
        guard turnCount % 2 == 0 else { return }
        /// Делаем небольшую задержку для комфорта
        sleep(2)
        /// Ход бота
        self.botTurn()
        
    }
    
    /// Старт игры
    mutating func start() {
        /// Проверка, на выбранный пустую ячейку
        guard chooseTacOrCross != .empty else {
            print("Выберите .croos or .tac")
            return
        }
        /// Проверка на запуск игры
        guard isStarted == false else {
            return print("Игра уже запущена")
        }
        /// Меняeм статус
        isStarted = false
        /// Заполняем поля
        fillInTheField()
        /// Принтуем
        printField()
        /// Разделяем принты
        print("==================")
        /// Если выбрал .cross бот начинает ходить первым
        if chooseTacOrCross == .tac {
            botTurn()
        }
    }
    
    /// Рестар игры
    mutating func restart() {
        print("Restarted")
        /// Обновляем все поля
        for x in 0..<fields.count {
            for y in 0..<fields[x].count {
                fields[y][x] = .empty
            }
        }
    }
}
/*
 1) Создаем экземпляр
 2) .start()
 3) .yourTurn(row: Int(0...2), column: Int(0...2))
 4) .restart - если захотели сыграть еще
 */
//var ttt = TicTacToe(chooseTacOrCross: .cross)
//ttt.start()
//ttt.yourTurn(1, 1)
//ttt.yourTurn(0, 0)


