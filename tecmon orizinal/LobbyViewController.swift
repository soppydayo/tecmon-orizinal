//
//  LobbyViewController.swift
//  TechMonster
//
//  Created by 木村結月 on 2023/11/11.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    var stamina: Int = 100
    var staminaTimer: Timer!
    
//アプリが起動した時一度だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIの設定
        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina) / 100"
    
        
        // Do any additional setup after loading the view.
        
        
        //タイマーの設定
        staminaTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfo: nil,
            repeats: true)
        staminaTimer.fire()
    }
    //ロビー画面が見えるようになる時に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    //ロビー画面が見えなくなる時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
        
    }
    
@IBAction func toBattle() {
    //スタミナが５０以上あればスタミナ50を消費して戦闘画面へ
    if stamina >= 50  {
        stamina -= 50
        staminaLabel.text = "\(stamina) / 100"
        performSegue(withIdentifier: "toBattle", sender: nil)
    } else {
        let alert = UIAlertController(
            title: "バトルに行けません",
            message: "スタミナをためてください",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default))
        present(alert, animated:  true)
    }
}

    //スタミナの回復
    @objc func updateStaminaValue() {
        if stamina < 100 {
            stamina += 1
            staminaLabel.text = "\(stamina) / 50"
        }
    }
    
    
    
    
    @IBAction func unwindSegue(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
