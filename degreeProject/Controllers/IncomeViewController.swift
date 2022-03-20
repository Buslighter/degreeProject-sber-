//
//  IncomeViewController.swift
//  degreeProject
//
//  Created by gleba on 18.03.2022.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var blackoutView: UIView!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var addIncomeBut: UIButton!
    @IBAction func addIncomeAction(_ sender: Any) {
//        func addblackout(){
//      //            let backgroundView = UIView()
//      //            backgroundView.backgroundColor = UIColor.black
//      //            backgroundView.alpha = 0.6
//      //            backgroundView.frame = self.view.frame
//      //            self.view.addSubview(backgroundView)
//      ////            containerViewIncome.isHidden = isInsertMode
//      //            isInsertMode = true
//      //
//      //
//      //        }
//      //        addblackout()
////              addIncomeView()
////              func addIncomeView(){
////                  let incomeInView = IncomeInputView(frame: CGRect(x: 0, y:mainView.frame.maxY, width: mainView.frame.width, height: 168))
////                  self.view.addSubview(incomeInView)
//              }
        
        blackoutView.isHidden = false
        
        
    }
    @IBOutlet weak var IncomeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addIncomeBut.layer.cornerRadius = CGFloat(18)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension IncomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! IncomeTableViewCell
        return cell
    }
    
    
}
