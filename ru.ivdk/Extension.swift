//
//  Extension.swift
//  ru.ivdk
//
//  Created by Арина Нефёдова on 12.12.2020.
//

import Foundation
import SwiftUI
import WebKit
import MapKit
import AVFoundation
import MediaPlayer

private struct SheetShape: Shape {
    var geometry: GeometryProxy
    let radius = 8

    func path(in rect: CGRect) -> Path {
        var rect = rect
        rect.size.height += geometry.safeAreaInsets.bottom
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public enum SheetHeight {
    case points(CGFloat)
    case percentage(CGFloat)
    /// When the provided content's height can be infered it will show up as that. ScrollView and List don't have this by default so they will show as 50%. You can use .frame(height:) to change that.
    case infered
    
    fileprivate func emptySpaceHeight(in size: CGSize) -> CGFloat? {
        switch self {
        case .points(let height):
            let remaining = size.height - height
            return max(remaining, 0)
        case .percentage(let percentage):
            precondition(0...100 ~= percentage)
            let remaining = 100 - percentage
            return size.height / 100 * remaining
        case .infered:
            return nil
        }
    }
}

private struct SafeAreaFillView: View {
    var geometry: GeometryProxy
    
    var body: some View {
        Color(.systemBackground)
            .frame(width: geometry.size.width, height: geometry.safeAreaInsets.bottom)
            .offset(y: geometry.safeAreaInsets.bottom)
    }
}

private struct ParentInvisible<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let host = UIHostingController(rootView: content())
        host.view.backgroundColor = .clear
        return host
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.parent?.view.backgroundColor = .clear
    }
}

private struct SheetView<Content: View>: View {
    var height: SheetHeight
    var content: () -> Content
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ParentInvisible {
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: self.height.emptySpaceHeight(in: geometry.size)).onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    ZStack(alignment: .bottom) {
                        SafeAreaFillView(geometry: geometry)
                        self.content().clipShape(SheetShape(geometry: geometry))
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}


enum  Orientation {
    case landscape
    case portrait
}
extension View {
    
        /// Presents a sheet.
        ///
        /// - Parameters:
        ///     - height: The height of the presented sheet.
        ///     - item: A `Binding` to an optional source of truth for the sheet.
        ///     When representing a non-nil item, the system uses `content` to
        ///     create a sheet representation of the item.
        ///
        ///     If the identity changes, the system will dismiss a
        ///     currently-presented sheet and replace it by a new sheet.
        ///
        ///     - onDismiss: A closure executed when the sheet dismisses.
        ///     - content: A closure returning the content of the sheet.
        public func sheet<Item: Identifiable, Content: View>(height: SheetHeight, item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View {
            self.sheet(item: item, onDismiss: onDismiss) { item in
                SheetView(height: height, content: { content(item) })
            }
        }
        
        /// Presents a sheet.
        ///
        /// - Parameters:
        ///     - height: The height of the presented sheet.
        ///     - isPresented: A `Binding` to whether the sheet is presented.
        ///     - onDismiss: A closure executed when the sheet dismisses.
        ///     - content: A closure returning the content of the sheet.
        public func sheet<Content: View>(height: SheetHeight, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
            self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                SheetView(height: height, content: content)
            }
        }
        
    
    func getOrientation(geometry:GeometryProxy) -> Orientation {
            let _  = geometry.size.width > geometry.size.height
            if   UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                return .landscape
            }
            else {
                return .portrait
            }
         }
    
    func artworkNamed(_ imageName: String) -> MPMediaItemArtwork? {
    
        
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
extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct Corners : Shape {
    
    var corner : UIRectCorner
    var size : CGSize
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: size)
        
        return Path(path.cgPath)
    }
}
struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}
struct CustomShape : Shape {
    
    var offset : CGFloat = 0.75
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * (1 - offset) ))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY * offset))
        path.closeSubpath()
        
        return path
    }
}

struct CustomShape2 : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: 0, y: rect.height)
            let pt3 = CGPoint(x: rect.width, y: rect.height)
            let pt4 = CGPoint(x: rect.width, y: 150)
            
            path.move(to: pt4)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 45)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 45)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 45)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 45)
        }
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                
                return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
               
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

struct WebView: UIViewRepresentable {

    var view = WKWebView()

    var url: URL
    func makeUIView(context: Context) -> WKWebView {

        view.load(URLRequest(url: url))
       // view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 9 * 16)
        view.scrollView.minimumZoomScale = 1.0
        view.scrollView.maximumZoomScale = 1.0
        view.backgroundColor = .white
        view.scrollView.isScrollEnabled = false
        view.isOpaque = false
        view.scrollView.setZoomScale(1.0, animated: false)
        view.scrollView.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    #if !targetEnvironment(macCatalyst)

    
    final class Coordinator: NSObject, UIScrollViewDelegate, UIWebViewDelegate {

        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            parent.view.scrollView.pinchGestureRecognizer?.isEnabled = false
            }

    }
    #endif
    
    #if targetEnvironment(macCatalyst)

    
    final class Coordinator: NSObject, UIScrollViewDelegate {

        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            parent.view.scrollView.pinchGestureRecognizer?.isEnabled = false
            }

    }
    #endif
}




struct ScrollableView<Content: View>: UIViewControllerRepresentable, Equatable {

    // MARK: - Coordinator
    final class Coordinator: NSObject, UIScrollViewDelegate {
        
        // MARK: - Properties
        private let scrollView: UIScrollView
        var offset: Binding<CGPoint>

        // MARK: - Init
        init(_ scrollView: UIScrollView, offset: Binding<CGPoint>) {
            self.scrollView          = scrollView
            self.offset              = offset
            super.init()
            self.scrollView.delegate = self
        }
        
        // MARK: - UIScrollViewDelegate
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.offset.wrappedValue = scrollView.contentOffset
            }
        }
    }
    
    // MARK: - Type
    typealias UIViewControllerType = UIScrollViewController<Content>
    
    // MARK: - Properties
    var offset: Binding<CGPoint>
    var animationDuration: TimeInterval
    var showsScrollIndicator: Bool
    var axis: Axis
    var content: () -> Content
    var onScale: ((CGFloat)->Void)?
    var disableScroll: Bool
    var forceRefresh: Bool
    var stopScrolling: Binding<Bool>
    private let scrollViewController: UIViewControllerType

    // MARK: - Init
    init(_ offset: Binding<CGPoint>, animationDuration: TimeInterval, showsScrollIndicator: Bool = true, axis: Axis = .vertical, onScale: ((CGFloat)->Void)? = nil, disableScroll: Bool = false, forceRefresh: Bool = false, stopScrolling: Binding<Bool> = .constant(false),  @ViewBuilder content: @escaping () -> Content) {
        self.offset               = offset
        self.onScale              = onScale
        self.animationDuration    = animationDuration
        self.content              = content
        self.showsScrollIndicator = showsScrollIndicator
        self.axis                 = axis
        self.disableScroll        = disableScroll
        self.forceRefresh         = forceRefresh
        self.stopScrolling        = stopScrolling
        self.scrollViewController = UIScrollViewController(rootView: self.content(), offset: self.offset, axis: self.axis, onScale: self.onScale)
    }
    
    // MARK: - Updates
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        self.scrollViewController
    }

    func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        
        viewController.scrollView.showsVerticalScrollIndicator   = self.showsScrollIndicator
        viewController.scrollView.showsHorizontalScrollIndicator = self.showsScrollIndicator
        viewController.updateContent(self.content)

        let duration: TimeInterval                = self.duration(viewController)
        let newValue: CGPoint                     = self.offset.wrappedValue
        viewController.scrollView.isScrollEnabled = !self.disableScroll
        
        if self.stopScrolling.wrappedValue {
            viewController.scrollView.setContentOffset(viewController.scrollView.contentOffset, animated:false)
            return
        }
        
        guard duration != .zero else {
            viewController.scrollView.contentOffset = newValue
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut, .beginFromCurrentState], animations: {
            viewController.scrollView.contentOffset = newValue
        }, completion: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self.scrollViewController.scrollView, offset: self.offset)
    }
    
    //Calcaulte max offset
    private func newContentOffset(_ viewController: UIViewControllerType, newValue: CGPoint) -> CGPoint {
        
        let maxOffsetViewFrame: CGRect = viewController.view.frame
        let maxOffsetFrame: CGRect     = viewController.hostingController.view.frame
        let maxOffsetX: CGFloat        = maxOffsetFrame.maxX - maxOffsetViewFrame.maxX
        let maxOffsetY: CGFloat        = maxOffsetFrame.maxY - maxOffsetViewFrame.maxY
        
        return CGPoint(x: min(newValue.x, maxOffsetX), y: min(newValue.y, maxOffsetY))
    }
    
    //Calculate animation speed
    private func duration(_ viewController: UIViewControllerType) -> TimeInterval {
        
        var diff: CGFloat = 0
        
        switch axis {
            case .horizontal:
                diff = abs(viewController.scrollView.contentOffset.x - self.offset.wrappedValue.x)
            default:
                diff = abs(viewController.scrollView.contentOffset.y - self.offset.wrappedValue.y)
        }
        
        if diff == 0 {
            return .zero
        }
        
        let percentageMoved = diff / UIScreen.main.bounds.height
        
        return self.animationDuration * min(max(TimeInterval(percentageMoved), 0.25), 1)
    }
    
    // MARK: - Equatable
    static func == (lhs: ScrollableView, rhs: ScrollableView) -> Bool {
        return !lhs.forceRefresh && lhs.forceRefresh == rhs.forceRefresh
    }
}

final class UIScrollViewController<Content: View> : UIViewController, ObservableObject {

    // MARK: - Properties
    var offset: Binding<CGPoint>
    var onScale: ((CGFloat)->Void)?
    let hostingController: UIHostingController<Content>
    private let axis: Axis
    lazy var scrollView: UIScrollView = {
        
        let scrollView                                       = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.canCancelContentTouches                   = true
        scrollView.delaysContentTouches                      = true
        scrollView.scrollsToTop                              = false
        scrollView.backgroundColor                           = .clear
        
        if self.onScale != nil {
            scrollView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.onGesture)))
        }
        
        return scrollView
    }()
    
    @objc func onGesture(gesture: UIPinchGestureRecognizer) {
        self.onScale?(gesture.scale)
    }

    // MARK: - Init
    init(rootView: Content, offset: Binding<CGPoint>, axis: Axis, onScale: ((CGFloat)->Void)?) {
        self.offset                                 = offset
        self.hostingController                      = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear
        self.axis                                   = axis
        self.onScale                                = onScale
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Update
    func updateContent(_ content: () -> Content) {
        
        self.hostingController.rootView = content()
        self.scrollView.addSubview(self.hostingController.view)
        
        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize
        
        switch axis {
            case .vertical:
                contentSize.width = self.scrollView.frame.width
            case .horizontal:
                contentSize.height = self.scrollView.frame.height
        }
        
        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize            = contentSize
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.createConstraints()
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Constraints
    fileprivate func createConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
struct TextView: UIViewRepresentable {
@Binding var text: String

func makeUIView(context: Context) -> UITextView {
    return UITextView()
}

func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.textColor = .blue
}
}


extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}
extension String {
    func replace() -> String {
        return self.replacingOccurrences(of: "\\n", with: "\n")
    }
    func newLines() -> String {
        let arr = self.replacingOccurrences(of: "\\n\\n", with: "\n").replacingOccurrences(of: "\\n", with: "\n").components(separatedBy: "\n")

        
        var text = ""
        for i in 0..<arr.count  {
            text += arr[i]
            
            if i != arr.count - 1{
                text += "\n"
            }
        }
        return text
    }
}


struct CarouselViewCity: View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var carouselLocation : Int
    
    var itemHeight:CGFloat
   @Binding var views : [CityCell]
    
    
    private func onDragEnded(drag: DragGesture.Value, _ i : CityView) {
        
        
        
        

        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation =  carouselLocation + 1
        }
        
        
        if (self.playerOdserve.cities[safe: relativeLoc()] != nil) {
            
            self.playerOdserve.focusCity = self.playerOdserve.cities[relativeLoc()]
            
            self.playerOdserve.updateMap = true
        }
        
    }
    @EnvironmentObject var playerOdserve : PlayerOdserve
   // @EnvironmentObject var data : IVDKobserve
    @State  var width = UIScreen.main.bounds.width
    
    var body: some View {
       // ZStack{
//            VStack{
//                Text("\(dragState.translation.width)")
//                Text("Carousel Location = \(carouselLocation)")
//                Text("Relative Location = \(relativeLoc())")
//                Text("\(relativeLoc()) / \(views.count-1)")
//                Spacer()
//            }
           // VStack{
                
                ZStack{
                    ForEach(0..<views.count){i in
                       // VStack{
                          //  Spacer()
                            self.views[i]
                                .padding(.leading, 20)
                                .environmentObject(playerOdserve)
                               // .environmentObject(data)
                                //Text("\(i)")
                            
                                .frame(width: width * 3 / 4 , height: self.getHeight(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                               
                            .shadow(radius: 3)
                                
                                
                            .opacity(self.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            .offset(x: self.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                
                                .gesture(
                                    
                                    DragGesture()
                                        .updating($dragState) { drag, state, transaction in
                                            state = .dragging(translation: drag.translation)
                                    }
                                        .onEnded({ (drag) in
                                            onDragEnded(drag: drag, self.playerOdserve.cities[i])
                                          })
                                    
                                )
                        
                       // }
                    }
                    
                }
               
               
                
            //    Spacer()
           // }
//            VStack{
//                Spacer()
//                Spacer().frame(height:itemHeight + 50)
//                Text("\(relativeLoc() + 1)/\(views.count)").padding()
//                Spacer()
//            }
      //  }
    }
    
    func relativeLoc() -> Int{
        return ((views.count * 10000) + carouselLocation) % views.count
    }
    
    func getHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - 100
        }
    }


    func getOpacity(_ i:Int) -> Double{
        
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        
        //This sets up the central offset
        if (i) == relativeLoc()
        {
            //Set offset of cental
            return self.dragState.translation.width
        }
            //These set up the offset +/- 1
        else if
            (i) == relativeLoc() + 1
                ||
                (relativeLoc() == views.count - 1 && i == 0)
        {
            //Set offset +1
            return self.dragState.translation.width + (300 + 20)
        }
        else if
            (i) == relativeLoc() - 1
                ||
                (relativeLoc() == 0 && (i) == views.count - 1)
        {
            //Set offset -1
            return self.dragState.translation.width - (300 + 20)
        }
            //These set up the offset +/- 2
        else if
            (i) == relativeLoc() + 2
                ||
                (relativeLoc() == views.count-1 && i == 1)
                ||
                (relativeLoc() == views.count-2 && i == 0)
        {
            return self.dragState.translation.width + (2*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 2
                ||
                (relativeLoc() == 1 && i == views.count-1)
                ||
                (relativeLoc() == 0 && i == views.count-2)
        {
            //Set offset -2
            return self.dragState.translation.width - (2*(300 + 20))
        }
            //These set up the offset +/- 3
        else if
            (i) == relativeLoc() + 3
                ||
                (relativeLoc() == views.count-1 && i == 2)
                ||
                (relativeLoc() == views.count-2 && i == 1)
                ||
                (relativeLoc() == views.count-3 && i == 0)
        {
            return self.dragState.translation.width + (3*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 3
                ||
                (relativeLoc() == 2 && i == views.count-1)
                ||
                (relativeLoc() == 1 && i == views.count-2)
                ||
                (relativeLoc() == 0 && i == views.count-3)
        {
            //Set offset -2
            return self.dragState.translation.width - (3*(300 + 20))
        }
            //This is the remainder
        else {
            return 10000
        }
    }
    
    
}


struct CarouselViewRoute: View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var carouselLocation : Int
    
    var itemHeight:CGFloat
   @Binding var views : [RouteCell]
    
    
    private func onDragEnded(drag: DragGesture.Value, _ i : CityView) {
        
        
        
        

        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation =  carouselLocation + 1
        }
        
        
//        if (self.data.cities[safe: relativeLoc()] != nil) {
//
//            self.data.focusCity = self.data.cities[relativeLoc()]
//
//            self.data.updateMap = true
//        }
        
    }
    @EnvironmentObject var playerOdserve : PlayerOdserve
   // @EnvironmentObject var data : IVDKobserve
    @State  var width = UIScreen.main.bounds.width
    
    var body: some View {
       // ZStack{
//            VStack{
//                Text("\(dragState.translation.width)")
//                Text("Carousel Location = \(carouselLocation)")
//                Text("Relative Location = \(relativeLoc())")
//                Text("\(relativeLoc()) / \(views.count-1)")
//                Spacer()
//            }
           // VStack{
                
                ZStack{
                    ForEach(0..<views.count){i in
                       // VStack{
                          //  Spacer()
                            self.views[i]
                              //  .padding(.leading, 20)
                                .environmentObject(playerOdserve)
                             //   .environmentObject(data)
                                //Text("\(i)")
                            
                                .frame(width: width * 3 / 4 , height: self.getHeight(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                               
                            .shadow(radius: 3)
                                
                                
                            .opacity(self.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            .offset(x: self.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                
                                .gesture(
                                    
                                    DragGesture()
                                        .updating($dragState) { drag, state, transaction in
                                            state = .dragging(translation: drag.translation)
                                    }
                                        .onEnded({ (drag) in
                                            onDragEnded(drag: drag, self.playerOdserve.cities[i])
                                          })
                                    
                                )
                        
                       // }
                    }
                    
                }
               
               
                
            //    Spacer()
           // }
//            VStack{
//                Spacer()
//                Spacer().frame(height:itemHeight + 50)
//                Text("\(relativeLoc() + 1)/\(views.count)").padding()
//                Spacer()
//            }
      //  }
    }
    
    func relativeLoc() -> Int{
        return ((views.count * 10000) + carouselLocation) % views.count
    }
    
    func getHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - 100
        }
    }


    func getOpacity(_ i:Int) -> Double{
        
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        
        //This sets up the central offset
        if (i) == relativeLoc()
        {
            //Set offset of cental
            return self.dragState.translation.width
        }
            //These set up the offset +/- 1
        else if
            (i) == relativeLoc() + 1
                ||
                (relativeLoc() == views.count - 1 && i == 0)
        {
            //Set offset +1
            return self.dragState.translation.width + (300 + 20)
        }
        else if
            (i) == relativeLoc() - 1
                ||
                (relativeLoc() == 0 && (i) == views.count - 1)
        {
            //Set offset -1
            return self.dragState.translation.width - (300 + 20)
        }
            //These set up the offset +/- 2
        else if
            (i) == relativeLoc() + 2
                ||
                (relativeLoc() == views.count-1 && i == 1)
                ||
                (relativeLoc() == views.count-2 && i == 0)
        {
            return self.dragState.translation.width + (2*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 2
                ||
                (relativeLoc() == 1 && i == views.count-1)
                ||
                (relativeLoc() == 0 && i == views.count-2)
        {
            //Set offset -2
            return self.dragState.translation.width - (2*(300 + 20))
        }
            //These set up the offset +/- 3
        else if
            (i) == relativeLoc() + 3
                ||
                (relativeLoc() == views.count-1 && i == 2)
                ||
                (relativeLoc() == views.count-2 && i == 1)
                ||
                (relativeLoc() == views.count-3 && i == 0)
        {
            return self.dragState.translation.width + (3*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 3
                ||
                (relativeLoc() == 2 && i == views.count-1)
                ||
                (relativeLoc() == 1 && i == views.count-2)
                ||
                (relativeLoc() == 0 && i == views.count-3)
        {
            //Set offset -2
            return self.dragState.translation.width - (3*(300 + 20))
        }
            //This is the remainder
        else {
            return 10000
        }
    }
    
    
}



struct Coor : Identifiable {
    var id = UUID()
    var coor : CLLocationCoordinate2D
    
}


enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation], distance : Double) {
        var zoomRect = MKMapRect.null
        var c = MKCircle()
        annotations.forEach { (annotation) in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y,
                                      width: 0.01, height: 0.01)
            
             c = MKCircle(center: annotation.coordinate, radius: CLLocationDistance(distance))
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100)
        setVisibleMapRect(c.boundingMapRect, edgePadding: insets, animated: true)
        
    }

}

struct CurrentPoint  : Equatable {
   
    static func ==(lhs: CurrentPoint, rhs: CurrentPoint) -> Bool {
            return lhs.point == rhs.point
        }
    var cityID : Int
    var routeID : Int

    var point : Point
}
extension CMTime {
    public var description: String {
        get {
            
            guard !(self.seconds.isNaN || self.seconds.isInfinite) else {
                return "er" // or do some error handling
            }
            
            let seconds = Int(round(self.seconds))
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }
    }
}


struct CarouselViewTest: View {
    
    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation = 0
    
    var itemHeight:CGFloat
    var views : [AnyView]
    
    
    private func onDragEnded(drag: DragGesture.Value) {
        
        
        
        

        let dragThreshold:CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold{
            carouselLocation =  carouselLocation - 1
        } else if (drag.predictedEndTranslation.width) < (-1 * dragThreshold) || (drag.translation.width) < (-1 * dragThreshold)
        {
            carouselLocation =  carouselLocation + 1
        }
        
        
//        if (self.data.cities[safe: relativeLoc()] != nil) {
//
//            self.data.focusCity = self.data.cities[relativeLoc()]
//
//            self.data.updateMap = true
//        }
        
    }
//    @EnvironmentObject var data : IVDKobserve
    @State  var width = UIScreen.main.bounds.width
    
    var body: some View {
       // ZStack{
//            VStack{
//                Text("\(dragState.translation.width)")
//                Text("Carousel Location = \(carouselLocation)")
//                Text("Relative Location = \(relativeLoc())")
//                Text("\(relativeLoc()) / \(views.count-1)")
//                Spacer()
//            }
           // VStack{
                
                ZStack{
                    ForEach(0..<views.count){i in
                       // VStack{
                          //  Spacer()
                            self.views[i]
                                //.padding(.leading, 20)
//                                .environmentObject(detailObject)
//                                .environmentObject(data)
                                //Text("\(i)")
                            
                                .frame(width: width * 3 / 4 , height: self.getHeight(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                               
                            .shadow(radius: 3)
                                
                                
                            .opacity(self.getOpacity(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                            .offset(x: self.getOffset(i))
                            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                
                                .gesture(
                                    
                                    DragGesture()
                                        .updating($dragState) { drag, state, transaction in
                                            state = .dragging(translation: drag.translation)
                                    }
                                        .onEnded({ (drag) in
                                            onDragEnded(drag: drag)
                                          })
                                    
                                )
                        
                       // }
                    }
                    
                }
               
               
                
            //    Spacer()
           // }
//            VStack{
//                Spacer()
//                Spacer().frame(height:itemHeight + 50)
//                Text("\(relativeLoc() + 1)/\(views.count)").padding()
//                Spacer()
//            }
      //  }
    }
    
    func relativeLoc() -> Int{
        return ((views.count * 10000) + carouselLocation) % views.count
    }
    
    func getHeight(_ i:Int) -> CGFloat{
        if i == relativeLoc(){
            return itemHeight
        } else {
            return itemHeight - 100
        }
    }


    func getOpacity(_ i:Int) -> Double{
        
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc()
        {
            return 1
        } else {
            return 0
        }
    }
    
    func getOffset(_ i:Int) -> CGFloat{
        
        //This sets up the central offset
        if (i) == relativeLoc()
        {
            //Set offset of cental
            return self.dragState.translation.width
        }
            //These set up the offset +/- 1
        else if
            (i) == relativeLoc() + 1
                ||
                (relativeLoc() == views.count - 1 && i == 0)
        {
            //Set offset +1
            return self.dragState.translation.width + (300 + 20)
        }
        else if
            (i) == relativeLoc() - 1
                ||
                (relativeLoc() == 0 && (i) == views.count - 1)
        {
            //Set offset -1
            return self.dragState.translation.width - (300 + 20)
        }
            //These set up the offset +/- 2
        else if
            (i) == relativeLoc() + 2
                ||
                (relativeLoc() == views.count-1 && i == 1)
                ||
                (relativeLoc() == views.count-2 && i == 0)
        {
            return self.dragState.translation.width + (2*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 2
                ||
                (relativeLoc() == 1 && i == views.count-1)
                ||
                (relativeLoc() == 0 && i == views.count-2)
        {
            //Set offset -2
            return self.dragState.translation.width - (2*(300 + 20))
        }
            //These set up the offset +/- 3
        else if
            (i) == relativeLoc() + 3
                ||
                (relativeLoc() == views.count-1 && i == 2)
                ||
                (relativeLoc() == views.count-2 && i == 1)
                ||
                (relativeLoc() == views.count-3 && i == 0)
        {
            return self.dragState.translation.width + (3*(300 + 20))
        }
        else if
            (i) == relativeLoc() - 3
                ||
                (relativeLoc() == 2 && i == views.count-1)
                ||
                (relativeLoc() == 1 && i == views.count-2)
                ||
                (relativeLoc() == 0 && i == views.count-3)
        {
            //Set offset -2
            return self.dragState.translation.width - (3*(300 + 20))
        }
            //This is the remainder
        else {
            return 10000
        }
    }
    
    
}

