//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Дима on 19.03.2024.
//

import Foundation

struct Calculation {
    let expression: [CalculationHistoryItem]
    let result: Double
}
extension Calculation: Codable {}
extension CalculationHistoryItem: Codable {
    enum CodingKeys: String, CodingKey {
        case num
        case operation
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .num(let value):
            try container.encode(value, forKey: CodingKeys.num)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    enum CalculationHistoryItemError: Error {
        case itemNotFound
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let num = try container.decodeIfPresent(Double.self, forKey: .num) {
            self = .num(num)
            return
        }
        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation),
           let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        throw CalculationHistoryItemError.itemNotFound
    }
}

class CalculationHistoryStorage {
    static let calculationHistoryKey = "calculationHistoryKey"
    func setHistory(calculation: [Calculation]) {
        if let encoded = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    func loadHistory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey){
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
}
