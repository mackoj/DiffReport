import Foundation
import ArgumentParser

extension Optional where Wrapped == Double {
  var orEmpty : String {
    get {
      switch self {
      case .none:
        return ""
      case .some(let dd):
        return "\(dd)"
      }
    }
  }
}

struct DiffReport: ParsableCommand {
  
  @Argument(help: "base test coverage file")
  var baseTestCoverageFilePath: String
  
  @Argument(help: "new test coverage file")
  var newTestCoverageFilePath: String
  
  @Argument(help: "output path")
  var outputFileName: String
  
  struct Coverage : Codable {
    let name : String
    let lineCoverage : Double
  }
  
  struct ReportLine : Codable, Identifiable {
    var id: String { get { name } }
    let name : String
    let lineCoverageOldValue : Double?
    let lineCoverageNewValue : Double?
  }
  
  func generateTable(_ base : [Coverage], _ new : [Coverage]) -> String {
    let baseDict = base.reduce(into: [String:Double]()) { $0[$1.name] = $1.lineCoverage }
    let newDict = new.reduce(into: [String:Double]()) { $0[$1.name] = $1.lineCoverage }
    
    let baseKeys = base.reduce(into: [String]()) { $0.append($1.name) }
    let newKeys = new.reduce(into: [String]()) { $0.append($1.name) }
    let keys : Set<String> = Set(baseKeys + newKeys)
    
    var output : [ReportLine] = keys.map { key in
      var lineCoverageOldValue : Double? = nil
      var lineCoverageNewValue : Double? = nil
      if baseKeys.contains(key) {
        lineCoverageOldValue = baseDict[key]
      }
      if newKeys.contains(key) {
        lineCoverageNewValue = newDict[key]
      }
      return ReportLine(
        name: key,
        lineCoverageOldValue: lineCoverageOldValue,
        lineCoverageNewValue: lineCoverageNewValue
      )
    }
    
    output.sort { (rlr, rll) -> Bool in
      return rlr.name < rll.name
    }
    
    var responseContent = output.map { (line) -> String in
      var state = "="
      if line.lineCoverageOldValue == nil {
        state = "NewValue"
      } else if line.lineCoverageNewValue == nil {
        state = "DeletedValue"
      } else if line.lineCoverageOldValue! == line.lineCoverageNewValue! {
        state = "="
      } else if line.lineCoverageOldValue! < line.lineCoverageNewValue! {
        state = "BetterThanBefore"
      } else if line.lineCoverageOldValue! > line.lineCoverageNewValue! {
        state = "WorseThanBefore"
      }
      return "| \(line.name) | \(line.lineCoverageOldValue.orEmpty) | \(line.lineCoverageNewValue.orEmpty) | \(state) |"
    }
    let arrayTop = """
  | Target | PreviousValue | NewValue | Diff |
  | --- | --- | --- | --- |
  """
    responseContent.insert(arrayTop, at: 0)
    return responseContent.joined(separator: "\n")
  }

  func fileToCoverage(_ inputFilePath : String) throws -> [Coverage] {
    let url = URL(fileURLWithPath: inputFilePath)
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([Coverage].self, from: data)
  }
  
  mutating func run() throws {
    let baseCoverage = try fileToCoverage(baseTestCoverageFilePath)
    let newCoverage = try fileToCoverage(newTestCoverageFilePath)
    
    let jsonCoverage = generateTable(baseCoverage, newCoverage)
    try jsonCoverage.write(toFile: outputFileName, atomically: true, encoding: .utf8)
  }
}

DiffReport.main()
