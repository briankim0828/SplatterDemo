//
//  VideoPlayerView.swift
//  Rift
//
//  Created by Brian Kim on 3/10/24.
//

//import SwiftUI
//import AVKit
//
//struct VideoPlayerView: UIViewControllerRepresentable {
//    
//    @Environment(PlayerModel.self) private var model
//
////    var url: URL
//    
//    let showContextualActions: Bool 
//    
//    init(showContextualActions: Bool) {
//        self.showContextualActions = showContextualActions
//    }
//
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        let controller = model.makePlayerViewController()
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
//        // Here you could update the controller, but there's no need for this example.
//    }
//}


import AVKit
import SwiftUI

// This view is a SwiftUI wrapper over `AVPlayerViewController`.
struct VideoPlayerView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
//        task{
//            print("updateUIViewController called")
//        }
    }

    @Environment(PlayerModel.self) private var model
    @Environment(VideoLibrary.self) private var library
    
    let showContextualActions: Bool
    let video: Video
    
    init(video: Video, showContextualActions: Bool) {
        print("initializing VideoPlayerView")
        self.video = video
        self.showContextualActions = showContextualActions
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        print("running makeUIViewController")
        
        
        // Create a player view controller.
//        let controller = model.makePlayerViewController(videoURL: library.videos[0].url)
        let videoFileName = video.fileName
        guard let url = Bundle.main.url(forResource: videoFileName, withExtension: nil) else {
            fatalError("Couldn't find \(videoFileName) in main bundle.")
        }
        let controller = model.makePlayerViewController(videoURL : url)

        print("1")
        
        // Enable PiP on iOS and tvOS.
        controller.allowsPictureInPicturePlayback = true

//        #if os(visionOS) || os(tvOS)
//        // Display an Up Next tab in the player UI.
//        if let upNextViewController {
//            controller.customInfoViewControllers = [upNextViewController]
//        }
//        #endif
        
        // Return the configured controller object.
        print("finished makeUIViewController")
        return controller
    }
    
//    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
//        #if os(visionOS) || os(tvOS)
//        Task { @MainActor in
//            // Rebuild the list of related video if necessary.
//            if let upNextViewController {
//                controller.customInfoViewControllers = [upNextViewController]
//            }
//            
//            if let upNextAction, showContextualActions {
//                controller.contextualActions = [upNextAction]
//            } else {
//                controller.contextualActions = []
//            }
//        }
//        #endif
//    }
    
    // A view controller that presents a list of Up Next videos.
//    var upNextViewController: UIViewController? {
//        guard let video = model.currentItem else { return nil }
//        
//        // Find the Up Next list for this video. Return early it there are none.
//        let videos = library.findUpNext(for: video)
//        if videos.isEmpty { return nil }
//
//        let view = UpNextView(videos: videos, model: model)
//        let controller = UIHostingController(rootView: view)
//        // AVPlayerViewController uses the view controller's title as the tab name.
//        // Specify the view controller's title before setting as a `customInfoViewControllers` value.
//        controller.title = view.title
//        // Set the preferred content size for the tab.
//        controller.preferredContentSize = CGSize(width: 500, height: isTV ? 250 : 150)
//        
//        return controller
//    }
    
    var upNextAction: UIAction? {
        // If there's no video loaded, return nil.
        guard let video = model.currentItem else { return nil }

        // Find the next video to play.
        guard let nextVideo = library.findVideoInUpNext(after: video) else { return nil }
        
        return UIAction(title: "Play Next", image: UIImage(systemName: "play.fill")) { _ in
            // Load the video for full-window presentation.
            model.loadVideo(nextVideo, presentation: .fullWindow)
        }
    }
}
