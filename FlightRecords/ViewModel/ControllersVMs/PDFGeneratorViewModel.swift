//
//  PDFGeneratorViewModel.swift
//  FlightRecords
//
//  Created by Martin Zid on 29/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import Foundation
import RealmSwift

class PDFGeneratorViewModel {
    
    private let records: Results<Record>?
    private let dateFormatter: DateFormatter
    
    private struct HTMLFiles {
        static let layout = "layout"
        static let table = "table"
        static let basicRow1 = "row01"
        static let basicRow2 = "row02"
        static let thisPageSumRow1 = "thisPageRow01"
        static let thisPageSumRow2 = "thisPageRow02"
        static let prevPagesSumRow1 = "prevPagesRow01"
        static let prevPagesSumRow2 = "prevPagesRow02"
        static let allPagesSumRow1 = "totalRow01"
        static let allPagesSumRow2 = "totalRow02"
    }
    
    private struct Marks {
        static let table = "#TABLE"
        static let basicRow1 = "#ROW01"
        static let basicRow2 = "#ROW02"
        
        static let date = "#DATE"
        static let from = "#DEPPLACE"
        static let tkoTime = "#DEPTIME"
        static let to = "#ARVPLACE"
        static let ldgTime = "#ARVTIME"
        static let planeType = "#TMVPLANE"
        static let planeRegistration = "#REGNOPLANE"
        static let singleEngine = "#SE"
        static let multiEngine = "#ME"
        static let multiPilot = "#MULTIPILOT"
        static let flightTime = "#FLIGHTTIME"
        static let pic = "#PIC"
        static let tkoDay = "#TKODAY"
        static let tkoNight = "#TKONIGHT"
        static let ldgDay = "#LDGDAY"
        static let ldgNight = "#LDGNIGHT"
        
        static let nightTime = "#NIGHTTIME"
        static let ifrTime = "#IFRTIME"
        static let picTime = "#PICTIME"
        static let coTime = "#COTIME"
        static let dualTime = "#DUALTIME"
        static let instructorTime = "#INSTRUCTORTIME"
        static let fstdDate = "#FSTDDATE"
        static let fstdType = "#FSTDTYPE"
        static let fstdTime = "#FSTDTIME"
        static let note = "#NOTE"
        
    }
    
    private enum DateTime {
        case date
        case time
    }
    
    private let recordOnPage = 12
    private let html = "html"
    
    init(with records: Results<Record>?) {
        self.records = records
        dateFormatter = DateFormatter()
    }
    
    func generateHTMLString() -> String? {
        let pathToLayout = Bundle.main.path(forResource: HTMLFiles.layout, ofType: html)
        do {
            var layout = try String(contentsOfFile: pathToLayout!)
            layout = layout.replacingOccurrences(of: Marks.table, with: try generateTables())
            return layout
        } catch {
            print("Unable to open and use HTML files.")
        }
        return nil
    }
    
    func numberOfPages() -> Int {
        let recordsCount = Double(records?.count ?? 0)
        return Int(floor(recordsCount / Double(recordOnPage))) + 1
    }
    
    private func generateTables() throws -> String {
        var tables = ""
        for page in 1...numberOfPages() {
            tables += try generateTable(for: page)
        }
        return tables
    }
    
    private func getContentsOfHTMLFile(for resource: String) throws -> String {
        let pathToResource = Bundle.main.path(forResource: resource, ofType: html)
        let contents = try String(contentsOfFile: pathToResource!)
        return contents
    }
    
    private func generateTable(for page: Int) throws -> String {
        var table = try getContentsOfHTMLFile(for: HTMLFiles.table)
        table = table.replacingOccurrences(of: Marks.basicRow1, with: try generateTableRows(for: page, generate: generateFirstTableRow))
        table = table.replacingOccurrences(of: Marks.basicRow2, with: try generateTableRows(for: page, generate: generateSecondTableRow))
        return table
    }
    
    private func generateTableRows(for page: Int, generate: (Record?) throws -> String) throws -> String {
        var rows = ""
        let pageStart = recordOnPage * (page - 1)
        let pageEnd = recordOnPage * page - 1
        for index in pageStart...pageEnd {
            var record: Record? = nil
            if let records = records {
                if index < records.count {
                    record = records[index]
                }
            }
            rows += try generate(record)
        }
        return rows
    }
    
    private func unwrapDateToString(date: Date?, mode: DateTime) -> String {
        var string = ""
        if let date = date {
            if mode == .date {
                string = dateFormatter.dateToString(from: date)
            } else if mode == .time {
                string = dateFormatter.timeToString(from: date)
            }
        }
        return string
    }
    private func unwrapNumberToString(value: Double?) -> String {
        var string = ""
        if let number = value {
            string = String(Int(number))
        }
        return string
    }
    
    private func getTMV(for plane: Plane?) -> String {
        var tmv = ""
        if let plane = plane {
            tmv += plane.type ?? ""
            tmv += plane.model ?? ""
            tmv += plane.variant ?? ""
        }
        return tmv
    }
    
    private func generateFirstTableRow(with record: Record?) throws -> String {
        var row = try getContentsOfHTMLFile(for: HTMLFiles.basicRow1)
        
        row = row.replacingOccurrences(of: Marks.date, with: unwrapDateToString(date: record?.date, mode: .date))
        row = row.replacingOccurrences(of: Marks.from, with: record?.from ?? "")
        row = row.replacingOccurrences(of: Marks.tkoTime, with: unwrapDateToString(date: record?.timeTKO, mode: .time))
        row = row.replacingOccurrences(of: Marks.to, with: record?.to ?? "")
        row = row.replacingOccurrences(of: Marks.ldgTime, with: unwrapDateToString(date: record?.timeLDG, mode: .time))
        row = row.replacingOccurrences(of: Marks.planeType, with: getTMV(for: record?.plane))
        row = row.replacingOccurrences(of: Marks.planeRegistration, with: record?.plane?.registrationNumber ?? "")
        row = row.replacingOccurrences(of: Marks.singleEngine, with: (record?.plane?.engine == .single) ? "X" : "")
        row = row.replacingOccurrences(of: Marks.multiEngine, with: (record?.plane?.engine == .multi) ? "X" : "")
        row = row.replacingOccurrences(of: Marks.multiPilot, with: "")
        row = row.replacingOccurrences(of: Marks.flightTime, with: record?.time ?? "")
        row = row.replacingOccurrences(of: Marks.pic, with: record?.pilot ?? "")
        row = row.replacingOccurrences(of: Marks.tkoDay, with: unwrapNumberToString(value: record?.tkoDay))
        row = row.replacingOccurrences(of: Marks.tkoNight, with: unwrapNumberToString(value: record?.tkoNight))
        row = row.replacingOccurrences(of: Marks.ldgDay, with: unwrapNumberToString(value: record?.ldgDay))
        row = row.replacingOccurrences(of: Marks.ldgNight, with: unwrapNumberToString(value: record?.ldgNight))
        
        return row
    }
    
    private func generateSecondTableRow(with record: Record?) throws -> String {
        var row = try getContentsOfHTMLFile(for: HTMLFiles.basicRow2)
        
        row = row.replacingOccurrences(of: Marks.nightTime, with: unwrapDateToString(date: record?.timeNight, mode: .time))
        row = row.replacingOccurrences(of: Marks.ifrTime, with: unwrapDateToString(date: record?.timeIFR, mode: .time))
        row = row.replacingOccurrences(of: Marks.picTime, with: unwrapDateToString(date: record?.timePIC, mode: .time))
        row = row.replacingOccurrences(of: Marks.coTime, with: unwrapDateToString(date: record?.timeCO, mode: .time))
        row = row.replacingOccurrences(of: Marks.dualTime, with: unwrapDateToString(date: record?.timeDUAL, mode: .time))
        row = row.replacingOccurrences(of: Marks.instructorTime, with: unwrapDateToString(date: record?.timeInstructor, mode: .time))
        row = row.replacingOccurrences(of: Marks.fstdDate, with: (record?.type == .simulator) ? unwrapDateToString(date: record?.date, mode: .date) : "")
        row = row.replacingOccurrences(of: Marks.fstdType, with: (record?.type == .simulator) ? record?.simulator ?? "" : "")
        row = row.replacingOccurrences(of: Marks.fstdTime, with: (record?.type == .simulator) ? record?.time ?? "" : "")
        row = row.replacingOccurrences(of: Marks.note, with: record?.note ?? "")
        
        return row
    }
}





