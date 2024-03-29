//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Дима on 05.03.2024.
//

import UIKit

enum CalculationError: Error {
    case devidedByZero
}

enum Operation: String {
    case add = "+"
    case sub = "-"
    case mult = "x"
    case div = "/"
    
    func calculate(_ num1: Double, _ num2: Double) throws -> Double {
        switch self {
        case .add: return num1 + num2
        case .sub: return num1 - num2
        case .mult: return num1 * num2
        case .div: 
            if num2 == 0 { throw CalculationError.devidedByZero}
            return num1 / num2
        }
    }
}

enum CalculationHistoryItem {
    case num(Double)
    case operation(Operation)
}
class ViewController: UIViewController {
    var calculationHistory: [CalculationHistoryItem] = []
    var calculations: [Calculation] = []
    let calculationHistoryStorage = CalculationHistoryStorage()
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }

        if buttonText == "," && label.text?.contains(",") == true { return }
        
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard 
            let buttonText = sender.titleLabel?.text,
            let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.num(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLableText()
    }
   
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        
        resetLableText()
    }
    
    private var res: String? = "NoData"
    
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.num(labelNumber))
        
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
            let newCalculation = Calculation(expression: calculationHistory, result: result, date: Date())
            calculations.append(newCalculation)
            calculationHistoryStorage.setHistory(calculation: calculations)
        }  catch {
            label.text = "Ошибка"
        }
        calculationHistory.removeAll()
    }
    
    @IBAction func showCalculationList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListViewController = sb.instantiateViewController(identifier: "CalculationsListViewController")
        if let vc = calculationsListViewController as? CalculationsListViewController {
            vc.calculations = calculations
        }
        navigationController?.pushViewController(calculationsListViewController, animated: true)
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var historyButton: UIButton!
   
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLableText()
        historyButton.accessibilityIdentifier = "historyButton"
        calculations = calculationHistoryStorage.loadHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func calculate() throws -> Double {
        guard case .num(let firstNum) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNum
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard case .operation(let operation) = calculationHistory[index],
                  case .num(let num) = calculationHistory[index + 1]
            else { break }
            currentResult = try operation.calculate(currentResult, num)
        }
        
        return currentResult
    }

    func resetLableText(){
        label.text = "0"
    }
}

