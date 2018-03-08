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
        static let totalRow1 = "totalRow01"
        static let totalRow2 = "totalRow02"
    }
    
    private struct Marks {
        static let table = "#TABLE"
        static let basicRow1 = "#ROW01"
        static let basicRow2 = "#ROW02"
        static let thisPage1 = "#THISPAGE01"
        static let thisPage2 = "#THISPAGE02"
        static let prevPages1 = "#PREVPAGES01"
        static let prevPages2 = "#PREVPAGES02"
        static let totalSum1 = "#TOTAL01"
        static let totalSum2 = "#TOTAL02"
        
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
    
    private let recordsOnPage = 12
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
            layout = localising(html: layout)
            return layout
        } catch {
            print("Unable to open and use HTML files.")
        }
        return nil
    }
    
    func numberOfPages() -> Int {
        let recordsCount = Double(records?.count ?? 0)
        let pages = Int(floor(recordsCount / Double(recordsOnPage)))
        if Int(recordsCount) % recordsOnPage == 0 { // number of record 12, 24, etc.
            return pages
        }
        return pages + 1
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
    
    private func fisrtRecordOn(page: Int) -> Int {
        return recordsOnPage * (page - 1)
    }
    
    private func lastRecordOn(page: Int) -> Int {
        var index = 0
        if let records = records {
            index = recordsOnPage * page - 1
            if index >= records.count {
                index = (records.count > 0) ? records.count - 1 : 0
            }
        }
        return index
    }
    
    private func generateTable(for page: Int) throws -> String {
        var table = try getContentsOfHTMLFile(for: HTMLFiles.table)
        
        let first = fisrtRecordOn(page: page)
        let last = lastRecordOn(page: page)
        var thisPageRecords: [Record]? = nil
        var prevPagesRecords: [Record]? = nil
        var totalPageRecords: [Record]? = nil
        if let records = records, records.count > 0 {
            thisPageRecords = Array(records[first...last])
            if page != 1 {
                let prevPageFirst = fisrtRecordOn(page: page-1)
                let prevPageLast = lastRecordOn(page: page-1)
                prevPagesRecords = Array(records[prevPageFirst...prevPageLast])
            }
            totalPageRecords = Array(records[0...last])
        }
        table = table.replacingOccurrences(of: Marks.basicRow1, with: try generateTableRows(for: page, generate: generateFirstTableRow))
        table = table.replacingOccurrences(of: Marks.basicRow2, with: try generateTableRows(for: page, generate: generateSecondTableRow))
        table = table.replacingOccurrences(of: Marks.thisPage1, with: try countFirstTableSums(from: thisPageRecords, template: HTMLFiles.thisPageSumRow1))
        table = table.replacingOccurrences(of: Marks.thisPage2, with: try countSecondsTableSums(from: thisPageRecords, template: HTMLFiles.thisPageSumRow2))
        table = table.replacingOccurrences(of: Marks.prevPages1, with: try countFirstTableSums(from: prevPagesRecords, template: HTMLFiles.prevPagesSumRow1))
        table = table.replacingOccurrences(of: Marks.prevPages2, with: try countSecondsTableSums(from: prevPagesRecords, template: HTMLFiles.prevPagesSumRow2))
        table = table.replacingOccurrences(of: Marks.totalSum1, with: try countFirstTableSums(from: totalPageRecords, template: HTMLFiles.totalRow1))
        table = table.replacingOccurrences(of: Marks.totalSum2, with: try countSecondsTableSums(from: totalPageRecords, template: HTMLFiles.totalRow2))
        return table
    }
    
    private func generateTableRows(for page: Int, generate: (Record?) throws -> String) throws -> String {
        var rows = ""
        let pageStart = fisrtRecordOn(page: page)
        let pageEnd = recordsOnPage * page - 1
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
    
    private func reduceSumToString(from values: [Int]) -> String {
        return String(values.reduce(0) { $0 + $1 })
    }
    
    private func countFirstTableSums(from records: [Record]?, template: String) throws -> String {
        var row = try getContentsOfHTMLFile(for: template)
        
        row = row.replacingOccurrences(of: Marks.multiPilot, with: "")
        row = row.replacingOccurrences(of: Marks.flightTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.filter{ $0.type == .flight }.map{ dateFormatter.createTime(from: $0.time!) }) : "" )
        row = row.replacingOccurrences(of: Marks.pic, with: "" )
        row = row.replacingOccurrences(of: Marks.tkoDay, with: (records != nil) ? reduceSumToString(from: records!.map{ Int($0.tkoDay) }) : "")
        row = row.replacingOccurrences(of: Marks.tkoNight, with: (records != nil) ? reduceSumToString(from: records!.map{ Int($0.tkoNight) }) : "")
        row = row.replacingOccurrences(of: Marks.ldgDay, with: (records != nil) ? reduceSumToString(from: records!.map{ Int($0.ldgDay) }) : "")
        row = row.replacingOccurrences(of: Marks.ldgNight, with: (records != nil) ? reduceSumToString(from: records!.map{ Int($0.ldgNight) }) : "")
        return row
    }
    
    private func countSecondsTableSums(from records: [Record]?, template: String) throws -> String {
        var row = try getContentsOfHTMLFile(for: template)
        
        row = row.replacingOccurrences(of: Marks.nightTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timeNight }) : "" )
        row = row.replacingOccurrences(of: Marks.ifrTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timeIFR }) : "" )
        row = row.replacingOccurrences(of: Marks.picTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timePIC }) : "" )
        row = row.replacingOccurrences(of: Marks.coTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timeCO }) : "" )
        row = row.replacingOccurrences(of: Marks.dualTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timeDUAL }) : "" )
        row = row.replacingOccurrences(of: Marks.instructorTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.map{ $0.timeInstructor }) : "" )
        row = row.replacingOccurrences(of: Marks.fstdDate, with: "" )
        row = row.replacingOccurrences(of: Marks.fstdType, with: "" )
        row = row.replacingOccurrences(of: Marks.fstdTime, with: (records != nil) ?
            dateFormatter.countTime(from: records!.filter{ $0.type == .simulator }.map{ dateFormatter.createTime(from: $0.time!) }) : "" )
        
        return row
    }
    
    private func localising(html: String) -> String {
        var localizedHTML = html
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THDATE", with: NSLocalizedString("Date", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THDEPARTURE", with: NSLocalizedString("Departure", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THARRIVAL", with: NSLocalizedString("Arrival", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPLANE", with: NSLocalizedString("Plane", comment: "").uppercased())
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THSINGLEPILOT", with: NSLocalizedString("Single pilot", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THMULTIPILOT", with: NSLocalizedString("Multi pilot", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTOTALTIME", with: NSLocalizedString("Total time", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPIC", with: NSLocalizedString("PIC name", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTKO", with: NSLocalizedString("Takeoffs", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THLDG", with: NSLocalizedString("Landings", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPLACE", with: NSLocalizedString("Place", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTIME", with: NSLocalizedString("Time", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTMV", with: NSLocalizedString("TMV", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THREGNO", with: NSLocalizedString("RegNo", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THDAYBR", with: NSLocalizedString("DayBR", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THNIGHTBR", with: NSLocalizedString("NightBR", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTHISPAGE", with: NSLocalizedString("This page total", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPREVPAGES", with: NSLocalizedString("Prev pages total", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTOTALTIME", with: NSLocalizedString("Total time", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THCONDITIONTIME", with: NSLocalizedString("Condition time", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPILOTTIME", with: NSLocalizedString("Pilot time", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THSIMULATOR", with: NSLocalizedString("Simulator records", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THNOTES", with: NSLocalizedString("Notes", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THNIGHT", with: NSLocalizedString("Night", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THPIC", with: NSLocalizedString("PIC", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THCO", with: NSLocalizedString("CO", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THDUAL", with: NSLocalizedString("Dual", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THINSTRUCTOR", with: NSLocalizedString("Instructor", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#THTYPE", with: NSLocalizedString("Type", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#TH2TOTALTIME", with: NSLocalizedString("Total time2", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#CERTIFICATION", with: NSLocalizedString("Certification", comment: ""))
        localizedHTML = localizedHTML.replacingOccurrences(of: "#SIGNATURE", with: NSLocalizedString("Pilot's signature", comment: ""))
        
        return localizedHTML
    }
}





