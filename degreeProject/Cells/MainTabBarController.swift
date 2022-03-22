//
//  MainTabBarController.swift
//  degreeProject
//
//  Created by gleba on 19.03.2022.
//

import UIKit
protocol delegateHeight{
    func getTBHeight(_ TBHeight: Double)
}
class MainTabBarController: UITabBarController {
    @IBOutlet var thisTabBar: UITabBar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        var delegate: delegateHeight?
        let tabFrame = self.thisTabBar.frame
            // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        let tabHeight = tabFrame.height
        delegate?.getTBHeight(tabHeight)
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
