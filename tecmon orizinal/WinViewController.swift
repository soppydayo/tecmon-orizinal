//
//  WinViewController.swift
//  tecmon orizinal
//
//  Created by 白川創大 on 2024/01/27.
//

import UIKit

class WinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func closeAllViewController(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
