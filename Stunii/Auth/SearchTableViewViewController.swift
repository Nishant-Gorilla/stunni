//
//  SearchTableViewViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 13/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SearchTableViewViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let csvData: [String] = Utilities.readFile("school", ofType: "csv")
    private var data: [String]!
    
    var selectionBlock: ((String?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        data = csvData
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if textField.text!.isEmpty {
            data = csvData
        }
        else {
            data = csvData.filter({$0.lowercased()
                .contains(textField.text!.lowercased())})
        }
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

extension SearchTableViewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTVCell
        cell.lbl.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionBlock?(data[indexPath.row])
        dismiss(animated: false, completion: nil)
    }
}



//MARK:- SearchCell
class SearchTVCell: UITableViewCell {
    @IBOutlet weak var lbl:UILabel!
}
