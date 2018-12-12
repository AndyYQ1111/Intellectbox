//
//  MPlayer.swift
//  FMT
//
//  Created by YueAndy on 2018/7/17.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit

class MPlayer: NSObject {
//    static let shared = MPlayer()
//
//    //要播放的list
//    var tracks:[Track]?
//    //播放器相关
//    var currentUrlStr:String?
//    var currentItem:AVPlayerItem?
//
//    let player:AVPlayer = AVPlayer()
//
//    var maxTime: Float = 0
//    //当前播放的是列表中的第几首
//    var currentIndex = 0
//
//    var isPlaying = false
//
//    typealias toTime = (_ toTime:Int)->()
//    var mToTime:toTime?
//
//    typealias toIndex = (_ toIndex:Int)->()
//    var mToIndex:toIndex?
//
//    //暂停
//    typealias pause = ()->()
//    var mPause:pause?
//
//
//    override init() {
//        super.init()
//        //添加播放结束的观察者
//        NotificationCenter.default.addObserver(self, selector: #selector(finish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//        //添加观察者
//        player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
//
//        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main, using: { (CMTime) in
//            if self.player.currentItem?.status == .readyToPlay {
//                //更新进度条进度值
//                let currentTime = CMTimeGetSeconds(self.player.currentTime())
//                //一个小算法，来实现00：00这种格式的播放时间
//                let all:Int=Int(currentTime)
//
//                self.mToTime!(all)
//            }
//        })
//    }
//
//    func play(tracks:[Track]){
//        self.tracks = tracks
//        //如果播放的同一首，就继续播放
//        //创建一个获取最大播放时长的现场
//        let track = self.tracks![currentIndex]
//        //如果播放的同一首，就继续播放
//        if(currentUrlStr == track.playUrl){
//            if(isPlaying == true){ // 正在播放，点击相同的歌曲
//                return
//            }else {//暂停回来继续播放
//                player.play()
//                isPlaying = true
//                return
//            }
//        }
//        if isPlaying == true{
//            player.pause()
//            isPlaying = false
//        }
//
//        currentUrlStr = track.playUrl
//        currentUrlStr = currentUrlStr?.replacingOccurrences(of: " ", with: "%20")
//        print(currentUrlStr as Any)
//        let musicUrl:URL = URL(string: currentUrlStr!)!
//        self.currentItem = AVPlayerItem(url: musicUrl)
//        player.replaceCurrentItem(with: self.currentItem)
//        player.play()
//        self.mToIndex!(currentIndex)
//    }
//
//    func pause() {
//        if isPlaying == false{
//            return
//        }
//        player.pause()
//        isPlaying = false
//        mPause!()
//    }
//
//    @objc func finish() {
//        print("播放停止")
//        print("播放完毕!")
//        currentItem?.seek(to: CMTime.zero)
//
//        currentIndex += 1
//        print("歌单数：\((self.tracks?.count ?? 0)) 下一首个：\(currentIndex)")
//        print(currentIndex)
//        if currentIndex > (self.tracks?.count)!-1{
//            currentIndex = 0
//            return
//        }
//        self.play(tracks: self.tracks!)
//    }
//
//    //回复初始设置
//    func restoreDefault(){
//        tracks = nil
//        currentUrlStr = nil
//        currentItem = nil
//
//        maxTime = 0
//        //当前播放的是列表中的第几首
//        currentIndex = 0
//        isPlaying = false
//    }
//
//    func stop() {
////        restoreDefault()
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    func seek(to:CMTime){
//        player.seek(to: to)
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "status" {
//            if player.status == .readyToPlay {
//                if isPlaying == true {
//                    return
//                }
//                player.play()
//                isPlaying = true
//            }
//        }
//    }
}
