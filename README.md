# Zakat-Calculator
An iOS Zakat (Charity) calculator featuring live metal API rates, dynamic currency conversion, offline Core Data history storage, and full Arabic/English localization.

## App Demo

https://github.com/user-attachments/assets/cf601bd8-1112-4fd2-a3dc-b1dcdb188a0b

## Technical Architecture and Features
### 1. Programmatic UI Layout (UIKit & Auto Layout)
- What i built: Developed entire user interface strictly via code, eliminating the use of storyboard and interface builder ( <code>.storyboard and .xib files</code> ). Every component including user input text fields, labels, buttons, cells, views and view controllers are initialized and configured programmatically using swift.
- How it was implemented: Leveraged the use of NSLayoutConstraints ( <code>topanchor, bottomanchor, leadinganchor, trailinganchor</code> ) to explicitly define the view hierarchy and relationships between UI elements. Set <code>translatesAutoresizingMaskIntoConstraints = false</code> on every programmatically created view to ensure it respects the custom constraint rules defined in the code.
- Why it matters:
  1. Fluid adaptibility: Building layout programatically ensures that the application scales and renders fluidly across all iPhone devices from the smaller iPhone SE to Pro Max Screens.
  2. Zero constraint conflict: Defining rules explicitly in the code prevents hidden interface builder bugs and compiler warnings, offering determinitic laypout behaviour.
  3. Clean code and Git friendliness: Bypassing storboards avoids large, unreadable XML merge conflicts in Git making the code highly scalable, modular and easier to code-review for a team
     of engineers.

     <pre><code style="white-space: pre-wrap !important;"> //Example of how i programatically achor views from precise layouts 
       
       customInputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
       customInputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
       customInputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
       customInputTextField.heightAnchor.constraint(equalToConstant: 50)
     </code></pre>

### 2. Networking and Local caching engine
- What i built: Implemented a robust networking layer to fetch real-time gold and silver market rates from an external REST API, paired with a custom time-sensitive
  local cache to ensure optimal app performance and offline capabilities.
- How it was implemented:
  1. Asynchronous networking: Utilized <code>URLSession</code> data tasks to handle asynchronous requests, safely handling HTTP status codes, networking error and       finally decoding the JSON data into native Swift models using <code>JSONDecoder</code>.
  2. Time-Based Cache Logic: To minimize API-rate limiting and eliminate redundant network overhead. Before making a network call the app checks <code> UserDefaults </code> for existing cached data. It decodes a custom data model (<code> CachedMetalData </code> ) and evaluated timestamp using <code>Calendar.current.isDateInToday </code>
- Why it matters:
  1. Network Efficiency: If the cache is valid for current day, the application instantly delivers the local data, completely saving an unecessary internet call.
  2. Full Offline Functionality: If the user loses internet connectivity or launches the app in airplane mode, then the engine directly falls back to the last
     successfully cached market price records, allowing seamless financial computations without a live connection!!

     <pre><code style="white-space: pre-wrap !important;"> // Check the cache first before hitting the network
     if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
         let cachedObj = try? JSONDecoder.decode(CachedMetalData.self, cachedData) {
 
         // Validate if the cached data belongs to today
         if Calendar.current.isDateInToday(cacheObj.downloadDate) {
           print("DEBUG: Using fresh local cache, saved internet call!")
           completed(.success(cachedObj.response))
           return 
           }
       }
     </code></pre>

### 3. Dual-Language Localization (English & Arabic RTL)
- What i built: Engineered full, native nulti-language localization supporting both English (Left-to-Right) and Arabic (Right-to-Left) languages. The app completely swaps the UI based on user's regional or selected preferences.
- The challenge: Standard layout techniques using hardcoded absolute coordinates or fixed horizontal properties like <code>leftAnchor</code> and <code>rightAnchor</code> completely fails when a UI has to be mirrored for an arabic user.
- The real-world bug: During testing, I discovered that while using semantic anchors <code>leadingAnchor</code> and <code>trailingAnchor</code> correctly mirrored the position of UI elements but certain text labels stubbornly remained misaligned, rendering text in the opposite resulting in incorrect alignment direction.
- How it was implemented & Solved:
  1. Dynamic layout mirroring: Eforced strict usage of semantic anchors <code> leadingAnchor </code> and <code> trailingAcnhor </code> through out the entire layout codebase.
  2. Manual alignment fixes: Resolved the inner text-alignment bug by implementing custom UI layout updates by manually checking the current layout direction and current language, then forcing the text alignments <code>.right</code> or <code>.left</code> conditionally to sync flawlessly with current language mode resulting in the seamless user experience for arabic users.
 
### 4. Data Persistence (Core Data)
- What i built: Integrated apple's native Core Data framework to save the computation history in the disk.
- How it was implemented: Designes a custom Core Data entity with attributes capturing calculation variables, calculated charity amounts, timestamp and currency flag. Managed data operations through <code>NSManagedObjectContext</code> implementing proper error handling in case if certain operation fails. Create a fetch request with sort descriptor to populate history logs in descending order.
- Why it matters
  1. Full offline independence: By bypassing external database servers. Users can securely save and acess historical charity records without any network connectivity.
  2. Clean UI: Implemented the historical records with <code>UITableViewDiffableDataSource</code> which offers clean animation when a certain calculated item is deleted.

### Design Pattern
- Architectural pattern: This application is structured using the Model-View-Controller (MVC) design with separating files design pattern. Keeping the codebase organized, testable and highly modular.
- Decoupling strategy: To avoid the "Massive View Controller" files, I enforces strict separation of concerns by yanking out the network call logic and configuration. The View Controller are exclusively responsible for rendering the UI layouts and handling user interactions.
- Separation of logic: All core business logic is cleanly decoupled. Networking tasks and data parsing are isolated inside a dedicated <code>NetworkManager</code> and configuration code of views inside their own files. This architectural boundary ensures that data layer remains completely agnostic of the user interface, making the codebase hihgly scalable and easier to maintain.

### Tech Stack & Tools Used
- Language: Swift
- Frameworks: UIKit, Core Data
- APIs: <code>URLSession</code> (REST API integration)
- Version Control: Git & GitHub
- IDE: Xcode


## How to Run the Project
1. Clone this repository: git clone https://github.com/sadiqjatu/Zakat-Calculator.git
2. Open the ZakatCalculator.xcodeproj in Xcode
3. Select an iOS simulator and press <code>cmd + R</code> to run.
