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

/**
 A UIViewController generating and displaying report as HTML table. It also can convert this table to PDF file and pass it to mail controller.
 */
class PDFGeneratorViewController: UIViewController, MFMailComposeViewControllerDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var pdfFilename = ""
    var viewModel: PDFGeneratorViewModel!
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.webView.loadHTMLString(self?.viewModel.generateHTMLString()! ?? "", baseURL: nil)
        })
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @IBAction func generate(_ sender: Any) {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.exportHTMLContentToPDF(HTMLContent: self?.viewModel.generateHTMLString()! ?? "")
            self?.activityIndicator.stopAnimating()
            self?.sendEmail()
        })
    }
    
    // MARK: - Helpers
    
    /**
     This function generates PDF file from given HTML and saves it to file.
     - parameters:
        - HTMLContent: String containing the HTML
    */
    private func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        let pdfData = drawPDFUsing(printPageRenderer: printPageRenderer)
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pdfFilename = "\(docDir)/PDF.pdf"
        print(pdfFilename)
        pdfData?.write(toFile: pdfFilename, atomically: true)
    }
    
    /**
     This function draw all pages of the PDF.
     - parameters:
        - printPageRenderer: UIPrintPageRenderer
    */
    private func drawPDFUsing(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        for i in 1...viewModel.numberOfPages() {
            UIGraphicsBeginPDFPage();
            printPageRenderer.drawPage(at: i - 1, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return data
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject(NSLocalizedString("Records", comment: ""))
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: pdfFilename)! as Data, mimeType: "application/pdf", fileName: NSLocalizedString("Records", comment: ""))
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Cant send email", comment: ""), message: NSLocalizedString("Unset email client", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
