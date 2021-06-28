//
//  HomeVC.swift
//  HwsP4
//
//  Created by Terry Kuo on 2021/6/28.
//

import UIKit

class HomeVC: UITableViewController {
    
    private let websites = ["apple.com", "hackingwithswift.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WebKit"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? ViewController {
            
            vc.urlString = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
