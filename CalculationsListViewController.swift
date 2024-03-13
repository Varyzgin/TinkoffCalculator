//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Дима on 13.03.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    @IBOutlet weak var calculationsLabel: UILabel!
    var result: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculationsLabel.text = result
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func dismissVC(sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
