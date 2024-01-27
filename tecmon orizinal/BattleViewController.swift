//
//  BattleViewController.swift
//  TechMonster
//
//  Created by 木村結月 on 2023/11/11.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    //ステータスの反映
    func updateUI() {
        //プレイヤーのステータスを反映
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        
        //敵のステータスを反映
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    //勝敗の判定
    func judgeBattle() {
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
            
        } else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        //プレイヤーのステータスを反映
        playerNameLabel.text = player.name
        playerImageView.image = player.image
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
        //敵のステータスを反映
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        
        updateUI()
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateGame),
            userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        techMonManager.stopBGM()
    }
    
    //0.1秒ごとにゲームの状況を更新する
    @objc func updateGame() {
        //プレイヤーのステータスを更新
        player.currentMP += 1
        if player.currentMP >= player.maxMP {
            isPlayerAttackAvailable = true
            player.currentMP = player.maxMP
        } else {
            isPlayerAttackAvailable = false
        }
        
        //敵のステータスを更新
        enemy.currentMP += 1
        if enemy.currentMP >= enemy.maxMP {
            enemyAttack()
            enemy.currentMP = 0
        }
        
        updateUI()
    }
    
    //敵の攻撃
    func enemyAttack() {
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        
        judgeBattle()
    }
    
    
    //勝敗が決定した時の処理
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        //リセット機能
        player.resetStatus()
        enemy.resetStatus()
        
        //var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            performSegue(withIdentifier: "Win", sender: self)
        } else {
            techMonManager.playSE(fileName: "SE_gameover")
            performSegue(withIdentifier: "Lose", sender: self)
        }
        
//        let alert = UIAlertController(
//            title: "バトル終了",
//            message: finishMessage,
//            preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//        }))
//        present(alert, animated: true)
    }
    
    @IBAction func chargeAction() {
        if isPlayerAttackAvailable {
            techMonManager.playSE(fileName: "SE_charge")
            
            player.currentTP += 40
            if player.currentTP >= player.maxTP {
                player.currentTP = player.maxTP
            }
            
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction() {
        if isPlayerAttackAvailable && player.currentTP >= 40 {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
             
            player.currentTP -= 100
            if player.currentTP <= 0 {
                player.currentTP = 0
            }
            
            player.currentMP = 0
            
            judgeBattle()
        }
    }
    
    //攻撃ボタンが押された時の処理
    @IBAction func attackAction() {
        if isPlayerAttackAvailable {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP -= player.attackPoint
            player.currentMP = 0
            
            player.currentTP += 10
            if player.currentTP >= player.currentTP {
                player.currentTP = player.maxTP
            }
            
            judgeBattle()
        }
    }
}

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


