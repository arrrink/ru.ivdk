//
//  Player.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 17.01.2021.
//

import Foundation
import MediaPlayer
import Combine
// Reasons for invoking the audio session interruption handler (except macOS).

class ConfigModel : ObservableObject {
    
    static var shared: ConfigModel!
    
    // The platform-specific customization of the NowPlayable protocol.
    
    let nowPlayableBehavior: NowPlayable
    
    // The data model describing the configuration to use for playback.
    
    var allowsExternalPlayback: Bool
    var assets: [ConfigAsset]
    var commandCollections: [ConfigCommandCollection] = []
    
    // Initialize a new configuration data model.
    
    init(nowPlayableBehavior: NowPlayable, route: [NowPlayableStaticMetadata]) {
        
        guard ConfigModel.shared == nil else { fatalError("ConfigModel must be a singleton") }
        
        self.nowPlayableBehavior = nowPlayableBehavior
        self.allowsExternalPlayback = nowPlayableBehavior.defaultAllowsExternalPlayback
        
        
        self.assets = route.map({ConfigAsset(metadata: $0)})
//            [ConfigAsset(metadata:
//                                    NowPlayableStaticMetadata(assetURL: URL(string: Link.link + "/routes/moscow/3/point/9/point.jpg")!,
//                                                                         mediaType: .audio,
//                                                                   isLiveStream: false,
//                                                                   title: "Bip Bop, The Movie",
//                                                                   artist: nil,
//
//                                                                   artwork: artworkNamed(Link.link + "/routes/moscow/3/point/9/point.jpg"),
//                                                                   albumArtist: nil,
//                                                                   albumTitle: nil)
//                        )]
 
        self.commandCollections = defaultCommandCollections
        
        ConfigModel.shared = self
    }
//     func setAsset() {
//
//
//        guard let url = URL(string: Link.link + "/routes/moscow/3/point/9/point.jpg") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.assets = [ConfigAsset(metadata:  NowPlayableStaticMetadata(assetURL: URL(string: "https://agency78.spb.ru/ivdkapp/routes/marks/1/point/8/audio.wav")!,
//                                                                             mediaType: .audio,
//                                                                       isLiveStream: false,
//                                                                       title: "Bip Bop, The Movie",
//                                                                       artist: nil,
//
//                                                                       artwork: MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
//                                                                        image
//                                                                       }),
//                                                                       albumArtist: nil,
//                                                                       albumTitle: nil))]
//
//            }
//        }.resume()
//    }
}



extension ConfigModel {
    
    // Create the assets with synthesized metadata.
    
//     var defaultAssets: [ConfigAsset] {
////
////        // Find the audio files in the app bundle.
////
//////        let song1URL = Bundle.main.url(forResource: "Song 1", withExtension: ".m4a")!
//////        let song2URL = Bundle.main.url(forResource: "Song 2", withExtension: ".m4a")!
//////        let song3URL = Bundle.main.url(forResource: "Song 3", withExtension: ".m4a")!
//       let videoURL =
////
////        // Create metadata.
////
//        let metadatas: [NowPlayableStaticMetadata] =  [
////
//////            NowPlayableStaticMetadata(assetURL: song1URL,
//////                                mediaType: .audio,
//////                                isLiveStream: false,
//////                                title: "First Song",
//////                                artist: "Singer of Songs",
//////                                artwork: artworkNamed("Song 1"),
//////                                albumArtist: "Singer of Songs",
//////                                albumTitle: "Songs to Sing"),
////
//            NowPlayableStaticMetadata(assetURL: videoURL,
//                                      mediaType: .audio,
//                                isLiveStream: false,
//                                title: "Bip Bop, The Movie",
//                                artist: nil,
//
//                                artwork: artworkNamed(Link.link + "/routes/moscow/3/point/9/point.jpg"),
//                                albumArtist: nil,
//                                albumTitle: nil),
////
//////            NowPlayableStaticMetadata(assetURL: song2URL,
//////                                mediaType: .audio,
//////                                isLiveStream: false,
//////                                title: "Second Song",
//////                                artist: "Other Singer",
//////                                artwork: artworkNamed("Song 2"),
//////                                albumArtist: "Singer of Songs",
//////                                albumTitle: "Songs to Sing"),
////
//////            NowPlayableStaticMetadata(assetURL: videoURL,
//////                                mediaType: .video,
//////                                isLiveStream: false,
//////                                title: "Bip Bop, The Sequel",
//////                                artist: nil,
//////                                artwork: nil,
//////                                albumArtist: nil,
//////                                albumTitle: nil),
////
//////            NowPlayableStaticMetadata(assetURL: song3URL,
//////                                mediaType: .audio,
//////                                isLiveStream: false,
//////                                title: "Third Song",
//////                                artist: "Singer of Songs",
//////                                artwork: artworkNamed("Song 3"),
//////                                albumArtist: "Singer of Songs",
//////                                albumTitle: "Songs to Sing")
//       ]
//
//        return metadatas.map { ConfigAsset(metadata: $0) }
//    }
    
    // Create the command collections, and enable a default set of commands.
    
    fileprivate var defaultCommandCollections: [ConfigCommandCollection] {
        
        // Arrange the commands into collections.
        
        let collection1 = [ConfigCommand(.pause, "Pause"),
                           ConfigCommand(.play, "Play"),
                           ConfigCommand(.stop, "Stop"),
                           ConfigCommand(.togglePausePlay, "Play/Pause")]
        let collection2 = [ConfigCommand(.nextTrack, "Next Track"),
                           ConfigCommand(.previousTrack, "Previous Track"),
                           ConfigCommand(.changeRepeatMode, "Repeat Mode"),
                           ConfigCommand(.changeShuffleMode, "Shuffle Mode")]
        let collection3 = [ConfigCommand(.changePlaybackRate, "Playback Rate"),
                           ConfigCommand(.seekBackward, "Seek Backward"),
                           ConfigCommand(.seekForward, "Seek Forward"),
                           ConfigCommand(.skipBackward, "Skip Backward"),
                           ConfigCommand(.skipForward, "Skip Forward"),
                           ConfigCommand(.changePlaybackPosition, "Playback Position")]
        let collection4 = [ConfigCommand(.rating, "Rating"),
                           ConfigCommand(.like, "Like"),
                           ConfigCommand(.dislike, "Dislike")]
        let collection5 = [ConfigCommand(.bookmark, "Bookmark")]
        let collection6 = [ConfigCommand(.enableLanguageOption, "Enable Language Option"),
                           ConfigCommand(.disableLanguageOption, "Disable Language Option")]
        
        // Create the collections.
        
        let registeredCommands = nowPlayableBehavior.defaultRegisteredCommands
        let disabledCommands = nowPlayableBehavior.defaultDisabledCommands
        
        let commandCollections = [
            ConfigCommandCollection("Playback", commands: collection1, registered: registeredCommands, disabled: disabledCommands),
            ConfigCommandCollection("Navigating Between Tracks", commands: collection2, registered: registeredCommands, disabled: disabledCommands),
            ConfigCommandCollection("Navigating Track Contents", commands: collection3, registered: registeredCommands, disabled: disabledCommands),
            ConfigCommandCollection("Rating Media Items", commands: collection4, registered: registeredCommands, disabled: disabledCommands),
            ConfigCommandCollection("Bookmarking Media Items", commands: collection5, registered: registeredCommands, disabled: disabledCommands),
            ConfigCommandCollection("Enabling Language Options", commands: collection6, registered: registeredCommands, disabled: disabledCommands)
        ]
        
        return commandCollections
    }
    
    // Create artwork.
    
    private func artworkNamed(_ imageName: String) -> MPMediaItemArtwork? {
    
        
        guard let url = URL(string: imageName) else { return nil}
        
        var imagePlayer = UIImage()
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                
                return }
            DispatchQueue.main.async() {
                imagePlayer = image
                
            }
        }.resume()
        return nil
    }
    
    
    
}

//extension UIImage {
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else {
//
//                return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}




struct ConfigAsset {
    
    // The `AVURLAsset` corresponding to an asset.
    
    let urlAsset: AVURLAsset
    
    var shouldPlay: Bool

    // Metadata properties of this asset.
    
    let metadata: NowPlayableStaticMetadata
    
    // Initialize a new asset.
    
    init(metadata: NowPlayableStaticMetadata) {
        
        self.urlAsset = AVURLAsset(url: metadata.assetURL)
        self.shouldPlay = true
        self.metadata = metadata
    }
    
}


struct ConfigCommand {
    
    // The command described by this configuration.
    
    let command: NowPlayableCommand
    
    // A displayable name for this configuration's command.
    
    let commandName: String
    
    // 'true' to register a handler for the corresponding MPRemoteCommandCenter command.
    
    var shouldRegister: Bool
    
    // 'true' to disable the corresponding MPRemoteCommandCenter command.
    
    var shouldDisable: Bool
    
    // Initialize a command configuration.
    
    init(_ command: NowPlayableCommand, _ commandName: String) {
        
        self.command = command
        self.commandName = commandName
        self.shouldDisable = false
        self.shouldRegister = false
    }
}

struct ConfigCommandCollection {
    
    // The displayable name of the collection.
    
    let collectionName: String
    
    // The commands that belong to this collection.
    
    var commands: [ConfigCommand]
    
    init(_ collectionName: String, commands allCommands: [ConfigCommand],
         registered registeredCommands: [NowPlayableCommand],
         disabled disabledCommands: [NowPlayableCommand]) {
        
        self.collectionName = collectionName
        self.commands = allCommands
        
        // Flag commands in this collection as needing to be disabled or registered,
        // as requested.
        
        for (index, command) in commands.enumerated() {
            
            if registeredCommands.contains(command.command) {
                commands[index].shouldRegister = true
            }
            
            if disabledCommands.contains(command.command) {
                commands[index].shouldDisable = true
            }
        }
    }
    
}



class IOSNowPlayableBehavior: NowPlayable {
    
   
    var defaultAllowsExternalPlayback: Bool { return true }
    
    var defaultRegisteredCommands: [NowPlayableCommand] {
        return [.togglePausePlay,
                .play,
                .pause,
                .nextTrack,
                .previousTrack,
                .skipBackward,
                .skipForward,
                .changePlaybackPosition,
                .changePlaybackRate,
                .enableLanguageOption,
                .disableLanguageOption
        ]
    }
    
    var defaultDisabledCommands: [NowPlayableCommand] {
        
        // By default, no commands are disabled.
        
        return []
    }
    
    // The observer of audio session interruption notifications.
    
    private var interruptionObserver: NSObjectProtocol!
    
    // The handler to be invoked when an interruption begins or ends.
    
    private var interruptionHandler: (NowPlayableInterruption) -> Void = { _ in }
    func handleNowPlayableConfiguration(commands: [NowPlayableCommand],
                                        disabledCommands: [NowPlayableCommand],
                                        commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus,
                                        interruptionHandler: @escaping (NowPlayableInterruption) -> Void) throws {
        
        // Remember the interruption handler.
        
        self.interruptionHandler = interruptionHandler
        
        // Use the default behavior for registering commands.
        
        try configureRemoteCommands(commands, disabledCommands: disabledCommands, commandHandler: commandHandler)
    }
    
    func handleNowPlayableSessionStart() throws {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        // Observe interruptions to the audio session.
        
        interruptionObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification,
                                                                      object: audioSession,
                                                                      queue: .main) {
            [unowned self] notification in
            self.handleAudioSessionInterruption(notification: notification)
        }
         
        try audioSession.setCategory(.playback, mode: .default)
        
         // Make the audio session active.
        
         try audioSession.setActive(true)
    }
    
    func handleNowPlayableSessionEnd() {
        
        // Stop observing interruptions to the audio session.
        
        interruptionObserver = nil
        
        // Make the audio session inactive.
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session, error: \(error)")
        }
    }
    
    func handleNowPlayableItemChange(metadata: NowPlayableStaticMetadata) {
        
        // Use the default behavior for setting player item metadata.
        
        setNowPlayingMetadata(metadata)
    }
    
    func handleNowPlayablePlaybackChange(playing: Bool, metadata: NowPlayableDynamicMetadata) {
        
        // Use the default behavior for setting playback information.
        
        setNowPlayingPlaybackInfo(metadata)
    }
    
    // Helper method to handle an audio session interruption notification.
    
    private func handleAudioSessionInterruption(notification: Notification) {
        
        // Retrieve the interruption type from the notification.
        
        guard let userInfo = notification.userInfo,
            let interruptionTypeUInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeUInt) else { return }
        
        // Begin or end an interruption.
        
        switch interruptionType {
            
        case .began:
            
            // When an interruption begins, just invoke the handler.
            
            interruptionHandler(.began)
            
        case .ended:
            
            // When an interruption ends, determine whether playback should resume
            // automatically, and reactivate the audio session if necessary.
            
            do {
                
                try AVAudioSession.sharedInstance().setActive(true)
                
                var shouldResume = false
                
                if let optionsUInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt,
                    AVAudioSession.InterruptionOptions(rawValue: optionsUInt).contains(.shouldResume) {
                    shouldResume = true
                }
                
                interruptionHandler(.ended(shouldResume))
            }
            
            // When the audio session cannot be resumed after an interruption,
            // invoke the handler with error information.
                
            catch {
                interruptionHandler(.failed(error))
            }
            
        @unknown default:
            break
        }
    }
    
}


enum NowPlayableInterruption {
    case began, ended(Bool), failed(Error)
}

// An app should provide a custom implementation of the `NowPlayable` protocol for each
// platform on which it runs.

protocol NowPlayable: AnyObject {
    
    // Customization point: default external playability.
    
    var defaultAllowsExternalPlayback: Bool { get }
    
    // Customization point: remote commands to register by default.
    
    var defaultRegisteredCommands: [NowPlayableCommand] { get }
    
    // Customization point: remote commands to disable by default.
    
    var defaultDisabledCommands: [NowPlayableCommand] { get }
    
    // Customization point: register and disable commands, provide a handler for registered
    // commands, and provide a handler for audio session interruptions (except macOS).
    
    func handleNowPlayableConfiguration(commands: [NowPlayableCommand],
                                        disabledCommands: [NowPlayableCommand],
                                        commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus,
                                        interruptionHandler: @escaping (NowPlayableInterruption) -> Void) throws
    
    // Customization point: start a `NowPlayable` session, either by activating an audio session
    // or setting a playback state, depending on platform.
    
    func handleNowPlayableSessionStart() throws
    
    // Customization point: end a `NowPlayable` session, to allow other apps to become the
    // current `NowPlayable` app, by deactivating an audio session, or setting a playback
    // state, depending on platform.
    
    func handleNowPlayableSessionEnd()
    
    // Customization point: update the Now Playing Info metadata with application-supplied
    // values. The values passed into this method describe the currently playing item,
    // and the method should (typically) be invoked only once per item.
    
    func handleNowPlayableItemChange(metadata: NowPlayableStaticMetadata)
    
    // Customization point: update the Now Playing Info metadata with application-supplied
    // values. The values passed into this method describe attributes of playback that
    // change over time, such as elapsed time within the current item or the playback rate,
    // as well as attributes that require asynchronous asset loading, which aren't available
    // immediately at the start of the item.
    
    // This method should (typically) be invoked only when the playback position, duration
    // or rate changes due to user actions, or when asynchonous asset loading completes.
    
    // Note that the playback position, once set, is updated automatically according to
    // the playback rate. There is no need for explicit period updates from the app.
    
    func handleNowPlayablePlaybackChange(playing: Bool, metadata: NowPlayableDynamicMetadata)
}

// Extension methods provide useful functionality for `NowPlayable` customizations.

extension NowPlayable {
    
    // Install handlers for registered commands, and disable commands as necessary.
    
    func configureRemoteCommands(_ commands: [NowPlayableCommand],
                                 disabledCommands: [NowPlayableCommand],
                                 commandHandler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) throws {
        
        // Check that at least one command is being handled.
        
        guard commands.count > 1 else { throw NowPlayableError.noRegisteredCommands }
        
        // Configure each command.
        
        for command in NowPlayableCommand.allCases {
            
            // Remove any existing handler.
            
            command.removeHandler()
            
            // Add a handler if necessary.
            
            if commands.contains(command) {
                command.addHandler(commandHandler)
            }
            
            // Disable the command if necessary.
            
            command.setDisabled(disabledCommands.contains(command))
        }
    }
    
    // Set per-track metadata. Implementations of `handleNowPlayableItemChange(metadata:)`
    // will typically invoke this method.
    
    func setNowPlayingMetadata(_ metadata: NowPlayableStaticMetadata) {
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        NSLog("%@", "**** Set track metadata: title \(metadata.title)")
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = metadata.mediaType.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    // Set playback info. Implementations of `handleNowPlayablePlaybackChange(playing:rate:position:duration:)`
    // will typically invoke this method.
    
    func setNowPlayingPlaybackInfo(_ metadata: NowPlayableDynamicMetadata) {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        NSLog("%@", "**** Set playback info: rate \(metadata.rate), position \(metadata.position), duration \(metadata.duration)")
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyCurrentLanguageOptions] = metadata.currentLanguageOptions
        nowPlayingInfo[MPNowPlayingInfoPropertyAvailableLanguageOptions] = metadata.availableLanguageOptionGroups
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
}
enum NowPlayableCommand: CaseIterable {
    
    case pause, play, stop, togglePausePlay
    case nextTrack, previousTrack, changeRepeatMode, changeShuffleMode
    case changePlaybackRate, seekBackward, seekForward, skipBackward, skipForward, changePlaybackPosition
    case rating, like, dislike
    case bookmark
    case enableLanguageOption, disableLanguageOption
    
    // The underlying `MPRemoteCommandCenter` command for this `NowPlayable` command.
    
    var remoteCommand: MPRemoteCommand {
        
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        switch self {
            
        case .pause:
            return remoteCommandCenter.pauseCommand
        case .play:
            return remoteCommandCenter.playCommand
        case .stop:
            return remoteCommandCenter.stopCommand
        case .togglePausePlay:
            return remoteCommandCenter.togglePlayPauseCommand
        case .nextTrack:
            return remoteCommandCenter.nextTrackCommand
        case .previousTrack:
            return remoteCommandCenter.previousTrackCommand
        case .changeRepeatMode:
            return remoteCommandCenter.changeRepeatModeCommand
        case .changeShuffleMode:
            return remoteCommandCenter.changeShuffleModeCommand
        case .changePlaybackRate:
            return remoteCommandCenter.changePlaybackRateCommand
        case .seekBackward:
            return remoteCommandCenter.seekBackwardCommand
        case .seekForward:
            return remoteCommandCenter.seekForwardCommand
        case .skipBackward:
            return remoteCommandCenter.skipBackwardCommand
        case .skipForward:
            return remoteCommandCenter.skipForwardCommand
        case .changePlaybackPosition:
            return remoteCommandCenter.changePlaybackPositionCommand
        case .rating:
            return remoteCommandCenter.ratingCommand
        case .like:
            return remoteCommandCenter.likeCommand
        case .dislike:
            return remoteCommandCenter.dislikeCommand
        case .bookmark:
            return remoteCommandCenter.bookmarkCommand
        case .enableLanguageOption:
            return remoteCommandCenter.enableLanguageOptionCommand
        case .disableLanguageOption:
            return remoteCommandCenter.disableLanguageOptionCommand
        }
    }
    
    // Remove all handlers associated with this command.
    
    func removeHandler() {
        remoteCommand.removeTarget(nil)
    }
    
    // Install a handler for this command.
    
    func addHandler(_ handler: @escaping (NowPlayableCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) {
        
        switch self {
            
        case .changePlaybackRate:
            MPRemoteCommandCenter.shared().changePlaybackRateCommand.supportedPlaybackRates = [1.0, 2.0]
            
        case .skipBackward:
            MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15.0]
            
        case .skipForward:
            MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15.0]
            
        default:
            break
        }

        remoteCommand.addTarget { handler(self, $0) }
    }
    
    // Disable this command.
    
    func setDisabled(_ isDisabled: Bool) {
        remoteCommand.isEnabled = !isDisabled
    }
    
}

struct NowPlayableStaticMetadata {
    
    let assetURL: URL                   // MPNowPlayingInfoPropertyAssetURL
    let mediaType: MPNowPlayingInfoMediaType
                                        // MPNowPlayingInfoPropertyMediaType
    let isLiveStream: Bool              // MPNowPlayingInfoPropertyIsLiveStream
    
    let title: String                   // MPMediaItemPropertyTitle
    let artist: String?                 // MPMediaItemPropertyArtist
    let artwork: MPMediaItemArtwork?    // MPMediaItemPropertyArtwork
    
    let albumArtist: String?            // MPMediaItemPropertyAlbumArtist
    let albumTitle: String?             // MPMediaItemPropertyAlbumTitle
    
}

struct NowPlayableDynamicMetadata {
    
    let rate: Float                     // MPNowPlayingInfoPropertyPlaybackRate
    let position: Float                 // MPNowPlayingInfoPropertyElapsedPlaybackTime
    let duration: Float                 // MPMediaItemPropertyPlaybackDuration
    
    let currentLanguageOptions: [MPNowPlayingInfoLanguageOption]
                                        // MPNowPlayingInfoPropertyCurrentLanguageOptions
    let availableLanguageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup]
                                        // MPNowPlayingInfoPropertyAvailableLanguageOptions
    
}

enum NowPlayableError: LocalizedError {
    
    case noRegisteredCommands
    case cannotSetCategory(Error)
    case cannotActivateSession(Error)
    case cannotReactivateSession(Error)

    var errorDescription: String? {
        
        switch self {
            
        case .noRegisteredCommands:
            return "At least one remote command must be registered."
            
        case .cannotSetCategory(let error):
            return "The audio session category could not be set:\n\(error)"
            
        case .cannotActivateSession(let error):
            return "The audio session could not be activated:\n\(error)"
            
        case .cannotReactivateSession(let error):
            return "The audio session could not be resumed after interruption:\n\(error)"
        }
    }
}

class AssetPlayer : ObservableObject {
    // Possible values of the `playerState` property.
    let publisherState = PassthroughSubject<PlayerState, Never>()
    
    
    var playerState: PlayerState = .stopped {
       didSet {
           #if os(macOS)
           NSLog("%@", "**** Set player state \(playerState), playbackState \(MPNowPlayingInfoCenter.default().playbackState.rawValue)")
           #else
           NSLog("%@", "**** Set player state \(playerState)")
           #endif
        
        
       
       }
   }
    var trackState : TrackState? = nil
 
    enum PlayerState {
        case stopped
        case playing
        case paused
        
    }
    enum TrackState {
        case nextTrack
        case previousTrack
       // case paused
    }
    
    // The app-supplied object that provides `NowPlayable`-conformant behavior.
    
    unowned let nowPlayableBehavior: NowPlayable
    
    // The player actually being used for playback. An app may use any system-provided
    // player, or may play content in any way that is wishes, provided that it uses
    // the NowPlayable behavior correctly.
    
    var player: AVQueuePlayer
    
    // A playlist of items to play.
    
    private let playerItems: [AVPlayerItem]
    
    // Metadata for each item.
    
    private let staticMetadatas: [NowPlayableStaticMetadata]
    
    // The internal state of this AssetPlayer separate from the state
    // of its AVQueuePlayer.
    
    
    
    // `true` if the current session has been interrupted by another app.
    
    private var isInterrupted: Bool = false
    
    // Private observers of notifications and property changes.
    
    private var itemObserver: NSKeyValueObservation!
    private var rateObserver: NSKeyValueObservation!
    private var statusObserver: NSObjectProtocol!
    
    // A shorter name for a very long property name.
    
    private static let mediaSelectionKey = "availableMediaCharacteristicsWithMediaSelectionOptions"
    
    // Initialize a new `AssetPlayer` object.
    
    init() throws {
        
        self.nowPlayableBehavior = ConfigModel.shared.nowPlayableBehavior
        
        // Get the subset of assets that the configuration actually wants to play,
        // and use it to construct the playlist.
        
        let playableAssets = ConfigModel.shared.assets.compactMap { $0.shouldPlay ? $0 : nil }
        
        self.staticMetadatas = playableAssets.map { $0.metadata }
        self.playerItems = playableAssets.map {
            AVPlayerItem(asset: $0.urlAsset, automaticallyLoadedAssetKeys: [AssetPlayer.mediaSelectionKey])
        }
        
        // Create a player, and configure it for external playback, if the
        // configuration requires.
        
        self.player = AVQueuePlayer(items: playerItems)

        player.allowsExternalPlayback = ConfigModel.shared.allowsExternalPlayback
        
        // Construct lists of commands to be registered or disabled.
        
        var registeredCommands = [] as [NowPlayableCommand]
        var enabledCommands = [] as [NowPlayableCommand]
        
        for group in ConfigModel.shared.commandCollections {
            registeredCommands.append(contentsOf: group.commands.compactMap { $0.shouldRegister ? $0.command : nil })
            enabledCommands.append(contentsOf: group.commands.compactMap { $0.shouldDisable ? $0.command : nil })
        }
        
        // Configure the app for Now Playing Info and Remote Command Center behaviors.
        
        try nowPlayableBehavior.handleNowPlayableConfiguration(commands: registeredCommands,
                                                               disabledCommands: enabledCommands,
                                                               commandHandler: handleCommand(command:event:),
                                                               interruptionHandler: handleInterrupt(with:))
        
        // Start playing, if there is something to play.
        
        if !playerItems.isEmpty {
            
            // Start a playback session.
            
            try nowPlayableBehavior.handleNowPlayableSessionStart()
            
            // Observe changes to the current item and playback rate.
            
            if player.currentItem != nil {
                
                itemObserver = player.observe(\.currentItem, options: .initial) {
                    [unowned self] _, _ in
                    self.handlePlayerItemChange()
                }
                
                rateObserver = player.observe(\.rate, options: .initial) {
                    [unowned self] _, _ in
                    self.handlePlaybackChange()
                }
                
                statusObserver = player.observe(\.currentItem?.status, options: .initial) {
                    [unowned self] _, _ in
                    self.handlePlaybackChange()
                }
            }
            
            // Start the player.
            
            play()
            
            
        }
    }
    
    // Stop the playback session.
    
    func optOut() {
        
        player.pause()
        itemObserver = nil
        rateObserver = nil
        statusObserver = nil

        playerState = .stopped
        player.removeAllItems()
       
        
        nowPlayableBehavior.handleNowPlayableSessionEnd()
    }
    
    // MARK: Now Playing Info
    
    // Helper method: update Now Playing Info when the current item changes.
    
     func handlePlayerItemChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        guard let currentItem = player.currentItem else {
            
            print("kek")
            
           // optOut()
            
            return }
        guard let currentIndex = playerItems.firstIndex (where: { $0 == currentItem }) else { return }
        
        // Set the Now Playing Info from static item metadata.
        
        let metadata = staticMetadatas[currentIndex]
        
        nowPlayableBehavior.handleNowPlayableItemChange(metadata: metadata)
    }
    
    // Helper method: update Now Playing Info when playback rate or position changes.
    
    private func handlePlaybackChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        
        print(player.items().count)
        
        
        guard let currentItem = player.currentItem else {
            print("hz")
           //
          //  trackState = .nextTrack
           // optOut();
            
           // self.assetPlayer.changeTrackTo(a)
            return }
        guard currentItem.status == .readyToPlay else { return }
        
        // Create language option groups for the asset's media selection,
        // and determine the current language option in each group, if any.
        
        // Note that this is a simple example of how to create language options.
        // More sophisticated behavior (including default values, and carrying
        // current values between player tracks) can be implemented by building
        // on the techniques shown here.
        
        let asset = currentItem.asset
        
        var languageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup] = []
        var currentLanguageOptions: [MPNowPlayingInfoLanguageOption] = []

        if asset.statusOfValue(forKey: AssetPlayer.mediaSelectionKey, error: nil) == .loaded {
            
            // Examine each media selection group.
            
            for mediaCharacteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
                guard mediaCharacteristic == .audible || mediaCharacteristic == .legible,
                    let mediaSelectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: mediaCharacteristic) else { continue }
                
                // Make a corresponding language option group.
                
                let languageOptionGroup = mediaSelectionGroup.makeNowPlayingInfoLanguageOptionGroup()
                languageOptionGroups.append(languageOptionGroup)
                
                // If the media selection group has a current selection,
                // create a corresponding language option.
                
                if let selectedMediaOption = currentItem.currentMediaSelection.selectedMediaOption(in: mediaSelectionGroup),
                    let currentLanguageOption = selectedMediaOption.makeNowPlayingInfoLanguageOption() {
                    currentLanguageOptions.append(currentLanguageOption)
                }
            }
        }
        
        // Construct the dynamic metadata, including language options for audio,
        // subtitle and closed caption tracks that can be enabled for the
        // current asset.
        
        let isPlaying = playerState == .playing
        let metadata = NowPlayableDynamicMetadata(rate: player.rate,
                                                  position: Float(currentItem.currentTime().seconds),
                                                  duration: Float(currentItem.duration.seconds),
                                                  currentLanguageOptions: currentLanguageOptions,
                                                  availableLanguageOptionGroups: languageOptionGroups)
        
        nowPlayableBehavior.handleNowPlayablePlaybackChange(playing: isPlaying, metadata: metadata)
    }
    
    // MARK: Playback Control
    
    // The following methods handle various playback conditions triggered by remote commands.
    
     func play() {
        
        switch playerState {
            
        case .stopped:
            playerState = .playing
            player.play()
            
            handlePlayerItemChange()

        case .playing:
            break
            
        case .paused where isInterrupted:
            playerState = .playing
            
        case .paused:
            playerState = .playing
            player.play()
        }
    }
    
     func pause() {
        
        switch playerState {
            
        case .stopped:
            break
            
        case .playing where isInterrupted:
            playerState = .paused
            
        case .playing:
            playerState = .paused
            player.pause()
            
        case .paused:
            break
        }
    }
    
     func togglePlayPause() {

        switch playerState {
            
        case .stopped:
            play()
            
        case .playing:
            pause()
            
        case .paused:
            play()
        }
    }
    
     func nextTrack() {
        
        if case .stopped = playerState { return }
        
        player.advanceToNextItem()
    }
    
    func changeTrackTo(_ item : NowPlayableStaticMetadata) {
       
       if case .stopped = playerState { return }
       
      // let currentItems = player.items()
      // let toIndex = item
       
      
        
       // nowPlayableBehavior.handleNowPlayableSessionEnd()
      // guard  toIndex > 0, toIndex <= playerItems.count else { seek(to: .zero); return }
        
       // pause()
      //  playerState = .stopped
        
       // print("pause")
        player.pause()
      // player.removeAllItems()
     
        let playerItem = AVPlayerItem(asset: AVAsset(url: item.assetURL), automaticallyLoadedAssetKeys: ["availableMediaCharacteristicsWithMediaSelectionOptions"])
        
       // player.replaceCurrentItem(with: playerItem)
        
        if player.canInsert(playerItem, after: player.currentItem) {
            print("canins")
           // player.removeAllItems()
            player.insert(playerItem, after: player.currentItem)
            player.seek(to: .zero)
            self.nextTrack()
            self.playerState = .playing
            player.play()
            self.nowPlayableBehavior.setNowPlayingMetadata(item)
        //    self.handlePlayerItemChange()
        }
        
       // player.replaceCurrentItem(with: <#T##AVPlayerItem?#>)
        
       
//        if player.canInsert(playerItem, after: nil) {
//            player.insert(playerItem, after: nil)
            
//        }
//            self.nowPlayableBehavior.setNowPlayingMetadata(item)
//           // self.nowPlayableBehavior.setNowPlayingPlaybackInfo(NowPlayableDynamicMetadata(rate: <#T##Float#>, position: <#T##Float#>, duration: <#T##Float#>, currentLanguageOptions: <#T##[MPNowPlayingInfoLanguageOption]#>, availableLanguageOptionGroups: <#T##[MPNowPlayingInfoLanguageOptionGroup]#>))
//           }
//        if case .playing = playerState {
//            nextTrack()
//            player.play()
//        }
        //play()
      // }
       // playerState = .playing
//       if case .playing = playerState {
//        player.play()
//        handlePlayerItemChange()
       // nextTrack()
        //player.advanceToNextItem()
       //}
        
   }
   
     func previousTrack() {
        
        if case .stopped = playerState { return }
        
        let currentTime = player.currentTime().seconds
        let currentItems = player.items()
        let previousIndex = playerItems.count - currentItems.count - 1
        
        guard currentTime < 3, previousIndex > 0, previousIndex < playerItems.count else { seek(to: .zero); return }
        
        player.removeAllItems()
        
        for playerItem in playerItems[(previousIndex - 1)...] {
            
            if player.canInsert(playerItem, after: nil) {
                player.insert(playerItem, after: nil)
            }
        }
        
        if case .playing = playerState {
            player.play()
        }
    }
    
    private func seek(to time: CMTime) {
        
        if case .stopped = playerState { return }
        
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) {
            isFinished in
            if isFinished {
                

                self.handlePlaybackChange()
            }
        }
    }
    
    private func seek(to position: TimeInterval) {
        seek(to: CMTime(seconds: position, preferredTimescale: 1))
    }
    
    private func skipForward(by interval: TimeInterval) {
        seek(to: player.currentTime() + CMTime(seconds: interval, preferredTimescale: 1))
    }
    
    private func skipBackward(by interval: TimeInterval) {
        seek(to: player.currentTime() - CMTime(seconds: interval, preferredTimescale: 1))
    }
    
    private func setPlaybackRate(_ rate: Float) {
        
        if case .stopped = playerState { return }
        
        player.rate = rate
    }
    
    private func didEnableLanguageOption(_ languageOption: MPNowPlayingInfoLanguageOption) -> Bool {
        
        guard let currentItem = player.currentItem else { return false }
        guard let (mediaSelectionOption, mediaSelectionGroup) = enabledMediaSelection(for: languageOption) else { return false }
        
        currentItem.select(mediaSelectionOption, in: mediaSelectionGroup)
        handlePlaybackChange()
        
        return true
    }
    
    private func didDisableLanguageOption(_ languageOption: MPNowPlayingInfoLanguageOption) -> Bool {
        
        guard let currentItem = player.currentItem else { return false }
        guard let mediaSelectionGroup = disabledMediaSelection(for: languageOption) else { return false }

        guard mediaSelectionGroup.allowsEmptySelection else { return false }
        currentItem.select(nil, in: mediaSelectionGroup)
        handlePlaybackChange()
        
        return true
    }
    
    // Helper method to get the media selection group and media selection for enabling a language option.
    
    private func enabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> (AVMediaSelectionOption, AVMediaSelectionGroup)? {
        
        // In your code, you would implement your logic for choosing a media selection option
        // from a suitable media selection group.
        
        // Note that, when the current track is being played remotely via AirPlay, the language option
        // may not exactly match an option in your local asset's media selection. You may need to consider
        // an approximate comparison algorithm to determine the nearest match.
        
        // If you cannot find an exact or approximate match, you should return `nil` to ignore the
        // enable command.
        
        return nil
    }
    
    // Helper method to get the media selection group for disabling a language option`.
    
    private func disabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> AVMediaSelectionGroup? {
        
        // In your code, you would implement your logic for finding the media selection group
        // being disabled.
        
        // Note that, when the current track is being played remotely via AirPlay, the language option
        // may not exactly determine a media selection group in your local asset. You may need to consider
        // an approximate comparison algorithm to determine the nearest match.
        
        // If you cannot find an exact or approximate match, you should return `nil` to ignore the
        // disable command.
        
        return nil
    }
    
    // MARK: Remote Commands
    
    // Handle a command registered with the Remote Command Center.
    
     func handleCommand(command: NowPlayableCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        
        switch command {
            
        case .pause:
            pause()
            print("pause fucc")

            publisherState.send(.paused)
               
            
            
        case .play:
            play()
            
            print("play fucc")
            publisherState.send(.playing)
            
        case .stop:
            optOut()
            
        case .togglePausePlay:
            togglePlayPause()
            
        case .nextTrack:
            nextTrack()
            
        case .previousTrack:
            previousTrack()
            
        case .changePlaybackRate:
            guard let event = event as? MPChangePlaybackRateCommandEvent else { return .commandFailed }
            setPlaybackRate(event.playbackRate)
            
        case .seekBackward:
            guard let event = event as? MPSeekCommandEvent else { return .commandFailed }
            setPlaybackRate(event.type == .beginSeeking ? -3.0 : 1.0)
            
        case .seekForward:
            guard let event = event as? MPSeekCommandEvent else { return .commandFailed }
            setPlaybackRate(event.type == .beginSeeking ? 3.0 : 1.0)
            
        case .skipBackward:
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            skipBackward(by: event.interval)
            
        case .skipForward:
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            skipForward(by: event.interval)
            
        case .changePlaybackPosition:
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            seek(to: event.positionTime)
            
        case .enableLanguageOption:
            guard let event = event as? MPChangeLanguageOptionCommandEvent else { return .commandFailed }
            guard didEnableLanguageOption(event.languageOption) else { return .noActionableNowPlayingItem }

        case .disableLanguageOption:
            guard let event = event as? MPChangeLanguageOptionCommandEvent else { return .commandFailed }
            guard didDisableLanguageOption(event.languageOption) else { return .noActionableNowPlayingItem }

        default:
            break
        }
        
        return .success
    }
    
    // MARK: Interruptions
    
    // Handle a session interruption.
    
    private func handleInterrupt(with interruption: NowPlayableInterruption) {
        
        switch interruption {
            
        case .began:
            isInterrupted = true
            
        case .ended(let shouldPlay):
            isInterrupted = false
            
            switch playerState {
                
            case .stopped:
                break
                
            case .playing where shouldPlay:
                player.play()
                
            case .playing:
                playerState = .paused
                
            case .paused:
                break
            }
            
        case .failed(let error):
            print(error.localizedDescription)
            optOut()
        }
    }
    
}
