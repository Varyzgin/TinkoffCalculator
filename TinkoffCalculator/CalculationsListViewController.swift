//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Дима on 13.03.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    var result: String?
    @IBOutlet weak var calculationLable: UILabel!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    required init?(coder: NSCoder){
        super.init(coder: coder)
        initialize()
    }
    private func initialize() {
        modalPresentationStyle = .overFullScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calculationLable.text = result
    }
}
