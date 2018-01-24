//
//  PDFGeneratorViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 24/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class PDFGeneratorViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    private var pdfFilename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pathToTable = Bundle.main.path(forResource: "table", ofType: "html")
        webView.loadHTMLString(generateHTMLString()!, baseURL: URL(fileURLWithPath: pathToTable!))
    }
    
    @IBAction func generate(_ sender: Any) {
        exportHTMLContentToPDF(HTMLContent: generateHTMLString()!)
        showOptionsAlert()
    }
    
    private func generateHTMLString() -> String? {
        let pathToTable = Bundle.main.path(forResource: "table", ofType: "html")
        let pathToItem = Bundle.main.path(forResource: "row", ofType: "html")
        
        do {
            var HTMLTable = try String(contentsOfFile: pathToTable!)
            var HTMLRow = try String(contentsOfFile: pathToItem!)
            
            var items = ""
            HTMLRow = HTMLRow.replacingOccurrences(of: "#NUMBER", with: "1")
            HTMLRow = HTMLRow.replacingOccurrences(of: "#NAME", with: "Martin")
            HTMLRow = HTMLRow.replacingOccurrences(of: "#ITEM", with: "Guitar")
            items += HTMLRow
            
            HTMLRow = try String(contentsOfFile: pathToItem!)
            HTMLRow = HTMLRow.replacingOccurrences(of: "#NUMBER", with: "2")
            HTMLRow = HTMLRow.replacingOccurrences(of: "#NAME", with: "Aja")
            HTMLRow = HTMLRow.replacingOccurrences(of: "#ITEM", with: "Book")
            items += HTMLRow
            
            HTMLTable = HTMLTable.replacingOccurrences(of: "#ITEM", with: items)
            
            return HTMLTable
        } catch {
            print("Unable to open and use HTML template files.")
        }
        return nil
    }
    
    private func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pdfFilename = "\(docDir)/PDF.pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    private func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
            let url = URL(fileURLWithPath: self.pdfFilename)
            self.webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertActionStyle.default) { (action) in
            
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
