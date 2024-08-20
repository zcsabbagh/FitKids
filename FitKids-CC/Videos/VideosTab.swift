//
//  VideosTab.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 3/1/24.
//

/* Firebase integration needed
    - Stream videos from appropriate URLs

    Amplitude integration needed
    - Track likes and dislikes, adding in videoURL as param
*/

import Foundation
import SwiftUI
import AVKit
import SwiftUI
import WebKit
import MessageUI


/* View code below */
struct VideosTab: View {
    
    @State private var categories = [
        Category(name: "Fitness Workouts", content: .subcategories(fitnessWorkoutsSubcategories)),
        Category(name: "Yoga Demos", content: .subcategories(yogaDemoSubcategories)),
        Category(name: "Fitness Demos", content: .subcategories(workoutDemoSubcategories)),
        Category(name: "Yoga Flows", content: .subcategories(yogaFlowSubcategories)),
        Category(name: "Mindfulness", content: .videos(sampleMindfulnessVideos))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 15) {
                    ForEach($categories) { $category in
                        if case .subcategories = category.content {
                            NavigationLink(destination: SubVideosTab(category: category)) {
                                CategoryItemView(category: category, baseColor: Color.blue)
                            }
                        } else if case .videos(let videos) = category.content {
                            NavigationLink(destination: VideoList(subcategory: Subcategory(name: category.name, videos: videos))) {
                                CategoryItemView(category: category, baseColor: Color.blue)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            // .navigationBarTitle("Categories", displayMode: .inline)
        }
    }
}

struct SubVideosTab: View {
    var category: Category
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 15) {
                if case .subcategories(let subcategories) = category.content {
                    ForEach(subcategories) { subcategory in
                        NavigationLink(destination: VideoList(subcategory: subcategory)) {
                            SubcategoryItemView(subcategory: subcategory, baseColor: Color.green)
                        }
                    }
                } else if case .videos(let videos) = category.content {
                    ForEach(videos) { video in
                        NavigationLink(destination: EachVideo(videoURL: video.videoURL)) {
                            VideoItemView(video: video, baseColor: Color.orange)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .navigationBarTitle(category.name, displayMode: .inline)
    }
}

struct VideoList: View {
    var subcategory: Subcategory
    
    var body: some View {
        List(subcategory.videos) { video in
            NavigationLink(destination: EachVideo(videoURL: video.videoURL)) {
                Text(video.title)
            }
        }
        .navigationBarTitle(subcategory.name, displayMode: .inline)
    }
}


struct EachVideo: View {
    var videoURL: URL
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFeedbackAlert = false

    var body: some View {
        WebView(url: videoURL)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.showingFeedbackAlert = true
                    }) {
                        Image(systemName: "arrow.left")
                    }
                }
            }
            .alert(isPresented: $showingFeedbackAlert) {
                Alert(
                    title: Text("Did you like the video?"),
                    message: Text(""),
                    primaryButton: .default(Text("👎")) {
                        // Handle thumbs down action, open mail app immediately
                        openMailApp()
                    },
                    secondaryButton: .destructive(Text("👍")) {
                        // Handle thumbs up action, navigate back immediately
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
    }

    func openMailApp() {
        let subject = "Feedback for \(videoURL)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let body = "Enter your feedback here...".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let recipients = "zsabbagh@candidsocial.app".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let mailtoURL = URL(string: "mailto:\(recipients)?subject=\(subject)&body=\(body)")!
        
        UIApplication.shared.open(mailtoURL)
    }
}

// struct FeedbackFormView: View {
//     var onDismiss: () -> Void
//     var videoURL: String

//     @State private var feedbackText: String = ""

//     var body: some View {
//         NavigationView {
//             Form {
//                 TextField("Feedback", text: $feedbackText)
//                 Button("Send Feedback") {
//                     openMailApp()
//                 }
//             }
//             .navigationBarTitle("Feedback", displayMode: .inline)
//             .navigationBarItems(trailing: Button("Cancel") {
//                 onDismiss()
//             })
//         }
//     }
    

// }

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var subject: String
    var recipients: [String]
    var messageBody: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setSubject(subject)
        mail.setToRecipients(recipients)
        mail.setMessageBody(messageBody, isHTML: false)
        return mail
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// WebView to load and display a video from a URL
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// Refactored VideoItemView component for reuse with dynamic color gradient
struct VideoItemView: View {
    let video: VideoItem
    let baseColor: Color // Added to take in a color

    var body: some View {
        VStack {
            // Placeholder for video thumbnail or icon
            Image(systemName: "video.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(baseColor)
            Text(video.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, -30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.black.opacity(0.7))
        }
        .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.2), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}

// Refactored CategoryItemView component for reuse with dynamic color gradient
struct CategoryItemView: View {
    let category: Category
    let baseColor: Color // Added to take in a color

    var body: some View {
        VStack {
            // Placeholder for category thumbnail or icon
            Image("")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(baseColor)
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, -30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.black.opacity(0.7))
        }
        .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.2), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}

// Refactored SubcategoryItemView component for reuse with dynamic color gradient
struct SubcategoryItemView: View {
    let subcategory: Subcategory
    let baseColor: Color // Added to take in a color

    var body: some View {
        VStack {
            // Placeholder for subcategory thumbnail or icon
            Image(systemName: "")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(baseColor)
            Text(subcategory.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, -30)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.black.opacity(0.7))
        }
        .background(LinearGradient(gradient: Gradient(colors: [baseColor.opacity(0.2), baseColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}



/* Data structure definitions below */
struct Category: Identifiable {
    let id = UUID()
    let name: String
    var content: CategoryContent
}

enum CategoryContent {
    case subcategories([Subcategory])
    case videos([VideoItem])
}

struct Subcategory: Identifiable {
    let id = UUID()
    let name: String
    var videos: [VideoItem]
}

struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let videoURL: URL
}


/* Fitness Categories & Videos */
let fitnessWorkoutsSubcategories = [
    Subcategory(name: "Abs Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Abs Workout") }),
    Subcategory(name: "Arms Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Arms Workout") }),
    Subcategory(name: "Back Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Back Workout") }),
    Subcategory(name: "Chest Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Chest Workout") }),
    Subcategory(name: "Legs Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Legs Workout") }),
    Subcategory(name: "Shoulders Workout", videos: sampleFitnessWorkoutVideos.filter { $0.title.contains("Shoulders Workout") }),
]

let sampleFitnessWorkoutVideos = [
    VideoItem(title: "Agility Workout #1", videoURL: URL(string: "https://fitkids.box.com/s/o8hdttoxqi7j20zfrpe5c8tashc1810p")!),
    VideoItem(title: "Agility Workout #2", videoURL: URL(string: "https://fitkids.box.com/s/mlltqmkhpkapg1eg0getp8yldqh5x0y2")!),
    VideoItem(title: "Agility Workout #3", videoURL: URL(string: "https://fitkids.box.com/s/mj0khel42zb8cu7fjndcaa8bvraoj84n")!),
    VideoItem(title: "Agility Workout #4", videoURL: URL(string: "https://fitkids.box.com/s/gzp2xkikef942qf9jlqg8am1lqn097u8")!),
    VideoItem(title: "Agility Workout #5", videoURL: URL(string: "https://fitkids.box.com/s/9n9d4rjatb4dqsixvfno3hr29qf2ww9t")!),
    VideoItem(title: "Core Workout #1", videoURL: URL(string: "https://fitkids.box.com/s/zl4tpiynhqkoy702umeif0d4bzljfsuu")!),
    VideoItem(title: "Core Workout #2", videoURL: URL(string: "https://fitkids.box.com/s/ngo1quqm9wn884h4peuilrs2c33cx616")!),
    VideoItem(title: "Core Workout #3", videoURL: URL(string: "https://fitkids.box.com/s/1e1bo8ty2pnfx23bld7gyt6k2ohyyrf3")!),
    VideoItem(title: "Core Workout #4", videoURL: URL(string: "https://fitkids.box.com/s/pdgvbe321fgkzkuwdb860ehaymqhdrms")!),
    VideoItem(title: "Core Workout #5", videoURL: URL(string: "https://fitkids.box.com/s/or5jv74693d8xhurow225tspn4cxrurp")!),
    VideoItem(title: "Lower Body Workout #1", videoURL: URL(string: "https://fitkids.box.com/s/zudkanntwmw5xsy5e6bb5c07ctus")!),
    VideoItem(title: "Lower Body Workout #2", videoURL: URL(string: "https://fitkids.box.com/s/zudkannlwmtw8xs9y5s6jbb5c07tctue")!),
    VideoItem(title: "Lower Body Workout #3", videoURL: URL(string: "https://fitkids.box.com/s/nhxws2bkh6ksdk1a21x34yjuxydxjvju")!),
    VideoItem(title: "Lower Body Workout #4", videoURL: URL(string: "https://fitkids.box.com/s/xjtg2jvq37l98t3pqfezbo4dwz9c4k7j")!),
    VideoItem(title: "Lower Body Workout #5", videoURL: URL(string: "https://fitkids.box.com/s/vzvpqvysy46ihv979ktmet34tno12mb9")!),
    VideoItem(title: "Upper Body Workout #1", videoURL: URL(string: "https://fitkids.box.com/s/k0b9jw72fg0zkpsp7d88nslu9vur836o")!),
    VideoItem(title: "Upper Body Workout #2", videoURL: URL(string: "https://fitkids.box.com/s/uf6880jtx71gjdkax7m2id3zvm05lm19")!),
    VideoItem(title: "Upper Body Workout #3", videoURL: URL(string: "https://fitkids.box.com/s/mznoogd4kz35bnn6cdnozp2g3diums19")!),
    VideoItem(title: "Upper Body Workout #4", videoURL: URL(string: "https://fitkids.box.com/s/npvvddsric2miumfu8m6b564005zgjej")!),
    VideoItem(title: "Full Body Workout #1", videoURL: URL(string: "https://fitkids.box.com/s/6w9c4uzt1j2ja0ros1vbpqup68pqauo4")!),
    VideoItem(title: "Full Body Workout #2", videoURL: URL(string: "https://fitkids.box.com/s/wdwizqojsvkni3wy3gh0uoa64khofqa7")!),
    VideoItem(title: "Full Body Workout #3", videoURL: URL(string: "https://fitkids.box.com/s/9j830jxn68s4e6r0q0o5ym66ucelyuz5")!),
    VideoItem(title: "Full Body Workout #4", videoURL: URL(string: "https://fitkids.box.com/s/joiexq843bae2bpb1o8nbxah0f0pufve")!),
    VideoItem(title: "Full Body Workout #5", videoURL: URL(string: "https://fitkids.box.com/s/fru5clkjzd6dzv4d2c6jc3d5r5yol9va")!),
    VideoItem(title: "Full Body Workout #6", videoURL: URL(string: "https://fitkids.box.com/s/n66cxiqsozpcyunjso27swt77qyyq5fn")!),
    VideoItem(title: "Full Body Workout #7", videoURL: URL(string: "https://fitkids.box.com/s/7bm3ct5z2xgy3b5eghz7b2feltrd19nf")!),
    VideoItem(title: "Full Body Workout #8", videoURL: URL(string: "https://fitkids.box.com/s/90smx76u79k9sa69auaozg4bcrzx4975")!),
    VideoItem(title: "Full Body Workout #9", videoURL: URL(string: "https://fitkids.box.com/s/wo90jxzbu8fcf11mfqy9pm59aio6n0fb")!),
    VideoItem(title: "Full Body Workout #10", videoURL: URL(string: "https://fitkids.box.com/s/gue0875lmygmubkc42xbrvj98ely7ktu")!),
    VideoItem(title: "Full Body Workout #11", videoURL: URL(string: "https://fitkids.box.com/s/1q9nwn4ucjgos83lxqkw4fjxhrasboqo")!),
    VideoItem(title: "Full Body Workout #12", videoURL: URL(string: "https://fitkids.box.com/s/xk8f1kfm2ud6cwomh9m970x6z0m30jm3")!),
    VideoItem(title: "Full Body Workout #13", videoURL: URL(string: "https://fitkids.box.com/s/s9z774p67icgl38ndcgcoaxpl2lru5rw")!),
    VideoItem(title: "Full Body Workout #14", videoURL: URL(string: "https://fitkids.box.com/s/thk3lio0kfhduqy56m3rdib09kcp6l2k")!),
    VideoItem(title: "Full Body Workout #15", videoURL: URL(string: "https://fitkids.box.com/s/6d4uahg4z113qhxapv2mg1sgw17z01pf")!),
    VideoItem(title: "Full Body Workout #16", videoURL: URL(string: "https://fitkids.box.com/s/i48z52ehsk732d0c5g3xskkr2l65qln0")!),
    VideoItem(title: "Full Body Workout #17", videoURL: URL(string: "https://fitkids.box.com/s/h1wqzr7buyiind3ulg435hwsxsky9itn")!),
    VideoItem(title: "Full Body Workout #18", videoURL: URL(string: "https://fitkids.box.com/s/uw291jp9zqxmrbhy7b0i52dxdhr6splu")!),
    VideoItem(title: "Full Body Workout #19", videoURL: URL(string: "https://fitkids.box.com/s/duk4fv5kai52qklzw3y2rk6et012gfg6")!),
     VideoItem(title: "Full Body Workout #20", videoURL: URL(string: "https://fitkids.box..com/s/1iwnmrxeb2ynjoy17icrwm6x51szaaom")!),
    VideoItem(title: "Full Body Workout #21", videoURL: URL(string: "https://fitkids.box.com/s/xrrwno4q6pa3b0x63f0vjwx8njznanga")!),
    VideoItem(title: "Full Body Workout #22", videoURL: URL(string: "https://fitkids.box.com/s/xevdpmgjajr4wqlrv0z6u81bqtp29egl")!),
    VideoItem(title: "Full Body Workout #23", videoURL: URL(string: "https://fitkids.box.com/s/5iroh3wl9wd1n9rjm3xpeb7s4x9j9ki9")!),
    VideoItem(title: "Full Body Workout #24", videoURL: URL(string: "https://fitkids.box.com/s/d92x2b9jgk9tbbllhwxb9lv8q7sjw85j")!),
    VideoItem(title: "Full Body Workout #25", videoURL: URL(string: "https://fitkids.box.com/s/x95u7a7sup2z53a1yzjt1v1az11n3maf")!),
    VideoItem(title: "Dance Fitness #1", videoURL: URL(string: "https://fitkids.box.com/s/aygjsdq4p6ho2k0n1ofphfh4s16ykncm")!),
    VideoItem(title: "Dance Fitness #2", videoURL: URL(string: "https://fitkids.box.com/s/hh28pnufk5agnzvczcurjjht51e8vvwm")!),
    VideoItem(title: "Dance Fitness #3", videoURL: URL(string: "https://fitkids.box.com/s/2jz209mkvfldaw64qac2pkzeo77umlw3")!),
    VideoItem(title: "Dance Fitness #4", videoURL: URL(string: "https://fitkids.box.com/s/8d83iz2iwp55b1z4ptf45m34v0kspoe2")!),
    // fitness workout videos end here
]

/* Yoga Demo Categories & Videos */
let yogaDemoSubcategories = [
    Subcategory(name: "Agility Yoga", videos: sampleYogaDemoVideos.filter { $0.title.contains("Agility Yoga") }),
    Subcategory(name: "Core Yoga", videos: sampleYogaDemoVideos.filter { $0.title.contains("Core Yoga") }),
    Subcategory(name: "Upper Body Yoga", videos: sampleYogaDemoVideos.filter { $0.title.contains("Upper Body Yoga") }),
    Subcategory(name: "Lower Body Yoga", videos: sampleYogaDemoVideos.filter { $0.title.contains("Lower Body Yoga") }),
]

let sampleYogaDemoVideos = [
    VideoItem(title: "Downward Facing Dog | Agility Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/govtefaup44grztfcnbi5mg9rgpub3xn")!),
    VideoItem(title: "Lizard Pose | Agility Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/bop4l6pk9mmgf5zoqv0onjmry3fhwqw5")!),
    VideoItem(title: "Pigeon Pose | Agility Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/b9y74u3fzx0j7e495xhd0cmayl6oe0bq")!),
    VideoItem(title: "Butterfly Pose | Core Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/7luzmcdkwpwxy907mbgqnlbd93j9hyjm")!),
    VideoItem(title: "Seated Spinal Twist | Core Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/gj4ob3ku8tie7l2bswek3ft3738kawqc")!),
    VideoItem(title: "Malasana Squat | Lower Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/brfnqbx0a4cptqd2b80fc4uxubtj09r1")!),
    VideoItem(title: "Supine Spinal Twist | Lower Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/wvwdcaqyvvdbyuo84imzj46jcb4pmmkh")!),
    VideoItem(title: "Bridge Pose | Upper Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/wg0yqic18nglgn3aksnnlfz6wu6avcue")!),
    VideoItem(title: "Cobra Pose | Upper Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/8wq4ku3lzpaah1wcfkgxxhwko7uydwye")!),
    VideoItem(title: "Spinal Twist | Upper Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/5gbeul5vvik7n7bbkmazamzpr8ootv93")!),
    VideoItem(title: "Extra Pose | Upper Body Yoga Demo", videoURL: URL(string: "https://fitkids.box.com/s/q6e2chemtrf8dqaeek1r6u7nix28izzb")!)
]

/* Fitness Demo Categories & Videos */
let workoutDemoSubcategories = [
    Subcategory(name: "Agility Movement Demo", videos: sampleWorkoutDemoVideos.filter { $0.title.contains("Agility") }),
    Subcategory(name: "Core Movement Demo", videos: sampleWorkoutDemoVideos.filter { $0.title.contains("Core") }),
    Subcategory(name: "Lower Body Movement Demo", videos: sampleWorkoutDemoVideos.filter { $0.title.contains("Lower Body") }),
    Subcategory(name: "Upper Body Movement Demo", videos: sampleWorkoutDemoVideos.filter { $0.title.contains("Upper Body") }),
]

let sampleWorkoutDemoVideos = [
    VideoItem(title: "Crossed Toe Touch | Agility Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/tuhenkeips5is71yt2d3miju35n9oeff")!),
    VideoItem(title: "Toe Touch Twist | Agility Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/tohfjuf6aenv2jp2d4u1l6kg9dl7yf3r")!),
    VideoItem(title: "Bound | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/gyiuahvhankk3a8wkkot00ednioo741u")!),
    VideoItem(title: "Hoop Jumps | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/etfxbmtualvniwb6djtz6cwp3li6wkbb")!),
    VideoItem(title: "In, Out, In, Out w/ Agility Ladder | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/cw304yei4c8md6d89avhbbhzdq6s5rty")!),
    VideoItem(title: "Leg Hops | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/1gi85c32olrv5ddpryu5035crb1lcfaj")!),
    VideoItem(title: "Skiers | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/706i2w8wbpkumkj7jp2d3hqqxoyqsxkc")!),
    VideoItem(title: "Speed Hand Walks | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/m955b8r3nhxncggzk6czt8sbdpfurqpv")!),
    VideoItem(title: "Speed Mountain Climbers | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/cb0dzvuf35oeu7ih1ey40msykbx6xfx2")!),
    VideoItem(title: "Twists | Agility Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/erhlacmwsr2nv0uuuf33frwtu8j0dxwz")!),
    VideoItem(title: "High Knees | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/u4fddr7r82shwg3tc5ou5jhreg2uimh0")!),
    VideoItem(title: "Ice Skaters | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/aphgmi1059t49klcwdea69nz83cuuxn9")!),
    VideoItem(title: "Inch Worms | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/d26w9pi3ichfcuv38n0b7uk66ffkonmc")!),
    VideoItem(title: "Single Leg Balance | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/6c1bn6avpc1u8ztd0vgr8q3d0sdzrhjm")!),
    VideoItem(title: "Skip Forward-Backward | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/3p9435127d4h415ekp8kjtf99836saic")!),
    VideoItem(title: "Toe Walks | Agility Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/h86idr08ib6ix32i6fnlythw8cvbehis")!),
    VideoItem(title: "Standing Side Reach | Core Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/d2e6drngmwa7pxm8z0hw6vv37obvrbyw")!),
    VideoItem(title: "Toe Touch Twists | Core Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/2hkq1xug5exulbzxry7e2vp2hnt3m7y9")!),
    VideoItem(title: "Bicycles with Sandbell | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/m7gudr4jewrndxx7s79udmdaexqyqxbi")!),
    VideoItem(title: "Crab Toe Touch | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/gi3e7fqdt8i7wx6n5y14z57n5nwm32oy")!),
    VideoItem(title: "Kickouts | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/kzaj9or7ctdpqib2qcw8ilau337hfbg0")!),
    VideoItem(title: "Mountain Climbers | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/8ll7t371hx6qtaq5yall0p7l8wxutkl9")!),
    VideoItem(title: "Seated Flutter Kicks | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/9bme4u9jvnr0nsmi9mapf9a66si7wsnr")!),
    VideoItem(title: "Seated Heel Drops | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/gq8pj3z55jjjbqo1y59fryd3abg2devr")!),
    VideoItem(title: "Side Bend w/ Kettlebell | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/wxb8dcq6rl8zulbetatwl0jhcf6eajhr")!),
    VideoItem(title: "Stand Up Bicycles w/ Sandbell | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/pzttj6ol1yveudsqfqlz2b6n3b377652")!),
    VideoItem(title: "Tic Tocks | Core Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/5u44z8143zvrhqz8hd7mzdcddo4p9sj8")!),
    VideoItem(title: "Heel Scoops | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/e40vd6t3agh9l8re85ait0xynbxl24pw")!),
    VideoItem(title: "High Kicks | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/akecfv6p4o41940ocuas3v7ln2qfg1tn")!),
    VideoItem(title: "Running Arms | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/5fchkpkotk4wqgwj6ckh7wrt5byq8z2k")!),
    VideoItem(title: "Side Bends | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/wtuc0gnh8pt27xqq2bmw6pqr35d0fwkv")!),
    VideoItem(title: "Spider Lunges | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/wk1h00ccmcpx6r098otx9au649b92tog")!),
    VideoItem(title: "Toe Touch | Core Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/n7ord2kumkboh93s5tz4ge715ryoqqk8")!),
    VideoItem(title: "Flamingo Stretch | Lower Body Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/fapbb73azyhosowxmy44heu5mefn9oy1")!),
    VideoItem(title: "Toe Touch | Lower Body Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/an7swzgv7aut1q3egn69keuj3eaid1qx")!),
    VideoItem(title: "Back Lunges w/ Sandbell | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/68pa0x8vznff4prx0r8z1shkbam17k1s")!),
    VideoItem(title: "Calf Raises | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/w7w2cy303y18yxc9t2d9i0lonh2wop94")!),
    VideoItem(title: "Duck Walk | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/qcjzojnvzeygxpgqgrpo0580e2v8rg3u")!),
    VideoItem(title: "Side Lunges | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/l6vldetaovwz07lk9ov131gymuuojrzc")!),
    VideoItem(title: "Single Leg Balance w/ Sandbell | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/a37xq8218xv0dsf079h01vscnwnenbvj")!),
    VideoItem(title: "Single Leg Toe Touch | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/42r9ip9a9mw0q4vh0myxkzju6p2sl8oz")!),
    VideoItem(title: "Squat Hold w/ Kettlebell | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/uajyorxodrq9xmrt4rymvol4yfa0q5zs")!),
    VideoItem(title: "Squat Jumps | Lower Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/prmg2pprg80iirow31134e32coe6ujyu")!),
    VideoItem(title: "Butt Kickers | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/w97rdjtkqhj95jegglpu8exfk57pa5k4")!),
    VideoItem(title: "Heel Walks | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/rz0a04akqedkcbw8whz5blnbbkjjmfa6")!),
    VideoItem(title: "High Kicks | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/rz0a04akqedkcbw8whz5blnbbkjjmfa6")!),
    VideoItem(title: "Knee Hugs | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/fg766spuwm2sdnv8lpz8n85aokn774ye")!),
    VideoItem(title: "Quad Stretch | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/povobbf0oi5kixii8bmed928rps1ibe1")!),
    VideoItem(title: "Toe Walks | Lower Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/e13o0v3z1ucb9wo2bapix4vh81kr0rae")!),
    VideoItem(title: "Cross Body Shoulder Stretch | Upper Body Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/w954gf56vcdhqbkuirlzgwlxrbfqqg63")!),
    VideoItem(title: "Shoulder Stretch | Upper Body Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/c3zlcxw91jdv40a6pr54zgn80j927fdm")!),
    VideoItem(title: "Tricep Stretch | Upper Body Cooldown Demo", videoURL: URL(string: "https://fitkids.box.com/s/c3zlcxw91jdv40a6pr54zgn80j927fdm")!),
    VideoItem(title: "Bicep Curls w/ Ankle Bands | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/emgek9gm8049c4kgdzv1yni8qsttioeo")!),
    VideoItem(title: "Hand Walks | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/keverfb06jj4m5udz5m9kozqrbjlbkxt")!),
    VideoItem(title: "High Plank | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/l1ij9h0h11mmk5tmg5tl9utxf92o87d1")!),
    VideoItem(title: "Inch Worms | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/rwp4x9151fx6rqq5m115dzsprs0u0taw")!),
    VideoItem(title: "Incline Push Ups | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/agkc0ss85tuu8iqs9yxcq78w2ld6wvwl")!),
    VideoItem(title: "Plank High 5's | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/2l4x82gofjq1ej62lg3ntkbueulytm27")!),
    VideoItem(title: "Push Ups | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/3a4k9b1yz58dwthr1dtq3yjba5gz8znn")!),
    VideoItem(title: "Rows w/ Sandbell | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/8we1s54yo3tzsafmrr18etlwwl7id4io")!),
    VideoItem(title: "Shoulder Taps | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/addb08muhfyvtbf2b5kzihu2v53ginjk")!),
    VideoItem(title: "Y's, T's, W's | Upper Body Movement Demo", videoURL: URL(string: "https://fitkids.box.com/s/tov3mymy04l2yueob7tubzdfjs67ao7o")!),
    VideoItem(title: "Air Drumming | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/sd6z3plaz0q87rui6qpzzf3m44olym2q")!),
    VideoItem(title: "Air Jump Rope | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/gynv6zfts8x39h837r2gc6ficzqfjj7i")!),
    VideoItem(title: "Air Punches | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/z10ouqgqhyfiz23tgflnbg32efdfxbxo")!),
    VideoItem(title: "Arm Circles | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/x0wp1dbfvp99ecictglk9ifk2z0xi7m5")!),
    VideoItem(title: "Jumping Jacks | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/u17oo5vu8mcuhuam8ggdd2nsw8l8sqav")!),
    VideoItem(title: "Seal Jacks | Upper Body Warm Up Demo", videoURL: URL(string: "https://fitkids.box.com/s/38knog2wf0tkruv5xc3fkvz94w84kj1f")!)
]

/* Sample Yoga Flow Categories & Videos */
let yogaFlowSubcategories = [
    Subcategory(name: "Agility Yoga Flow", videos: sampleYogaFlowVideos.filter { $0.title.contains("Agility Yoga Flow") }),
    Subcategory(name: "Core Yoga Flow", videos: sampleYogaFlowVideos.filter { $0.title.contains("Core Yoga Flow") }),
    Subcategory(name: "Lower Body Yoga Flow", videos: sampleYogaFlowVideos.filter { $0.title.contains("Lower Body Yoga Flow") }),
    Subcategory(name: "Upper Body Yoga Flow", videos: sampleYogaFlowVideos.filter { $0.title.contains("Upper Body Yoga Flow") }),
    Subcategory(name: "Yoga Flow", videos: sampleYogaFlowVideos.filter { $0.title.contains("Yoga Flow") && !$0.title.contains("Agility") && !$0.title.contains("Core") && !$0.title.contains("Lower Body") && !$0.title.contains("Upper Body") }),
]

let sampleYogaFlowVideos = [
    VideoItem(title: "Agility Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/fegst9e4gosgsarpy1utlvfydae9fm18")!),
    VideoItem(title: "Core Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/2wmzqxf3vzaf6g2dc6eoevofxkblkzns")!),
    VideoItem(title: "Lower Body Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/pcgtzol4v4o94ay8h0e1fvs6ch66qbe4")!),
    VideoItem(title: "Upper Body Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/maogw2o0ca4ue2yr8js1qxnor4et2x78")!),
    VideoItem(title: "All 4's | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/kjwwr2r8pehsaii04ssmiqiwea0bo8u7")!),
    VideoItem(title: "Sun Salutation | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/0szni4di4zthtw47tc6rwruw4jrbctju")!),
    VideoItem(title: "Dance of Shiva | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/7ipjvuqqjepxbfxcq8hs7nm6567c8x44")!),
    VideoItem(title: "Mirror | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/8cdubkgg4q68fz6rh90ln4v31w3pr74j")!),
    VideoItem(title: "Tic Toc | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/pdgplm8segz675f27dbnes30nhoqljpl")!),
    VideoItem(title: "Balance | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/6nq3o9igk9gkkeb5vdqdnjzg8pepah47")!),
    VideoItem(title: "Core & Strength | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/sxgklli7upsfi08amzb4qje8alo9oxyy")!),
    VideoItem(title: "Floor Flex | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/qyn7pe5qe471kv5et86bv7494tkbf717")!),
    VideoItem(title: "Focus & Concentration | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/zxte26vxtk83o4peyi7kevmzl5b2zo26")!),
    VideoItem(title: "Serenity | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/djbqzyx01nk3gid904doj4kglptkqyv6")!),
    VideoItem(title: "Strong & Humble | Yoga Flow", videoURL: URL(string: "https://fitkids.box.com/s/wf9a0cyx8niitwjoide06kpyak6izny8")!)
]

/* Sample Mindfulness Videos */
let sampleMindfulnessVideos = [
    VideoItem(title: "Body Scan | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/upisrk2a2chn4d8tb65tdunr64jmhfqc")!),
    VideoItem(title: "Heartbeat Exercise | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/upzrepey8o7l8rcbec6to97dj4fafsho")!),
    VideoItem(title: "Mindful Bubbles | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/lcsxob20q8qj6w8c92jlp9gk4lmqzuub")!),
    VideoItem(title: "Mindful Posing | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/dugyyrd70vhqqkpwt5siadvcbk9f9b82")!),
    VideoItem(title: "Chest and Belly Breathing | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/deklyqgghg4agu7kcxus90qz643q521p")!),
    VideoItem(title: "Face Relaxation | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/b0e1vsl4d3ed3johk4b4q034qulkrm4m")!),
    VideoItem(title: "Finding Peace | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/0cj4jqidm2w3ponsfcn4xoy9n55y6jeu")!),
    VideoItem(title: "Limitless Potential | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/0e75peulx96aw18700vkk7bf3h8pq39y")!),
    VideoItem(title: "Peace & Kindness | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/zh3es1caia38whx1odionvpy8wh5l8wo")!),
    VideoItem(title: "Breathing | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/bvx7fljuxxxhu1nxxp10x7n8vzqkb8sw")!),
    VideoItem(title: "Calming Breath | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/oengk2vjbnr8cykdwz2evzfgh0nesl4i")!),
    VideoItem(title: "Mantra | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/1yise2tka3trkj3kqk30s1c7bbopu3mx")!),
    VideoItem(title: "Still & Quiet | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/rybwrhh84t3qlgnayv1n2uzyku2expi6")!),
    VideoItem(title: "Tapping | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/yj5njefg23fzk517xfk72iyz42l2hkdk")!),
    VideoItem(title: "Visualization | Mindfulness", videoURL: URL(string: "https://fitkids.box.com/s/jgf9cbug8aam8i0i0f5m7ery6anpoyzl")!)
]


// Form to send an email with feedback


// Preview provider for SwiftUI previews
struct VideosTab_Previews: PreviewProvider {
    static var previews: some View {
        VideosTab()
    }
}

