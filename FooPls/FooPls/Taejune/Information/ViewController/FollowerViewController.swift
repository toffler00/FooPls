
import UIKit

class FollowerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupUI() {
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FollowerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension FollowerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FollowCell
        return cell
    }
}
