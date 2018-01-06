//
//  FollowingViewController.swift
//  FooPls
//
//  Created by SIMA on 2018. 1. 5..
//  Copyright © 2018년 SONGYEE SHIN. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupUI() {
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}

extension FollowingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
