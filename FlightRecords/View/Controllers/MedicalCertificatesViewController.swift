//
//  MedicalCertificatesViewController.swift
//  FlightRecords
//
//  Created by Martin Zid on 08/12/2017.
//  Copyright © 2017 Martin Zid. All rights reserved.
//

import UIKit

class MedicalCertificatesViewController: UITableViewController {

    private var viewModel: MedicalCertificatesViewModel!
    
    private struct Identifiers {
        static let certificateCellIdentifier = "CertificatedCell"
        static let addCertificate = "addCertificate"
        static let medicalCertificatesSB = "medicalCertificates"
        static let addMedicalCertificateVC = "AddMedicalCertificateViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MedicalCertificatesViewModel()
        bindViewModel()
    }
    
    private func bindViewModel() {
        observeSignalForTableDataChanges(with: viewModel.collectionChangedSignal)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfCertificatesInSection() > 0 {
            deleteEmptyTableMessage()
            return viewModel.numberOfCertificatesInSection()
        } else {
            displayEmptyTableMessage(message: NSLocalizedString("Empty certificates table", comment: ""),
                                     subMessage: NSLocalizedString("Add new certificate info", comment: ""))
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.certificateCellIdentifier, for: indexPath) as! CertificateViewCell
        
        cell.viewModel = viewModel.getCellViewModel(for: indexPath)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteAction { [weak self] _ in
                self?.viewModel.deleteCertificate(at: indexPath)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = UIStoryboard(name: Identifiers.medicalCertificatesSB, bundle: nil).instantiateViewController(withIdentifier: Identifiers.addMedicalCertificateVC) as! AddMedicalCertificateViewController
        nextViewController.viewModel = viewModel.getAddCertificateViewModel(for: indexPath)
        let navigationController = UINavigationController(rootViewController: nextViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}
