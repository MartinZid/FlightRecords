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

class PDFGeneratorViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    private var pdfFilename = ""
    var viewModel: PDFGeneratorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(viewModel.generateHTMLString()!, baseURL: nil)
    }
    
    @IBAction func generate(_ sender: Any) {
        exportHTMLContentToPDF(HTMLContent: viewModel.generateHTMLString()!)
        sendEmail()
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
        
        for i in 1...viewModel.numberOfPages() {
            UIGraphicsBeginPDFPage();
            printPageRenderer.drawPage(at: i - 1, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return data
    }
    
//    func showOptionsAlert() {
//        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertControllerStyle.alert)
//
//        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
//            let url = URL(fileURLWithPath: self.pdfFilename)
//            self.webView.loadFileURL(url, allowingReadAccessTo: url)
//        }
//
//        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertActionStyle.default) { (action) in
//            DispatchQueue.main.async {
//                self.sendEmail()
//            }
//        }
//
//        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertActionStyle.default) { (action) in
//
//        }
//
//        alertController.addAction(actionPreview)
//        alertController.addAction(actionEmail)
//        alertController.addAction(actionNothing)
//
//        present(alertController, animated: true, completion: nil)
//    }
    
    
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject(NSLocalizedString("Records", comment: ""))
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: pdfFilename)! as Data, mimeType: "application/pdf", fileName: NSLocalizedString("Records", comment: ""))
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
