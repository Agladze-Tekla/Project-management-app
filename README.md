#  Project Management App

This iOS application is designed to help users efficiently organize their active projects and tasks in one place. Built with **Swift** and the **MVVM (Model-View-ViewModel) architecture**, it ensures modularity, scalability, and maintainability. **Firebase** is integrated for user authentication and data persistence.

---

##  Features

###  Project & Task Management

- Users can **create multiple projects**, each containing a set of tasks.
- Tasks can have **deadlines, priorities, and completion statuses**.
- Implements **data persistence** with **Cloud Firestore**, ensuring user data is synced across devices.

###  Weekly Planner

- Displays **tasks for the current week**, helping users stay organized.
- **Dynamic filtering** ensures only relevant tasks are shown based on due dates.

###  Progress Tracking

- Each project has a **progress indicator** based on completed tasks.
- Users can **view detailed task breakdowns** and track completion percentages.



---

##  Tech Stack & Architecture

###  **Technology Used**

- **Swift** – Primary programming language.
- **Xcode** – Development environment.
- **MVVM Architecture** – Ensures separation of concerns and better testability.
- **Firebase (Firestore & Authentication)** – Manages user data securely and enables cloud syncing.

###  **App Architecture**

This project follows the **MVVM (Model-View-ViewModel)** pattern to improve maintainability:

- **Model**: Defines the data structure (Projects, Tasks) and interacts with Firebase.
- **ViewModel**: Handles business logic, processes data for the View, and interacts with the Model.
- **View (SwiftUI/UIKit)**: Displays data and listens for user interactions.

###  **Key Development Practices**

- **Dependency Injection**: Used for better testability and reusability of components.
- **Protocol-Oriented Programming (POP)**: Ensures modularity and flexibility in business logic.
- **Reactive Programming (Combine)**: Enables real-time UI updates from Firebase data changes.
- **Swift Concurrency (async/await)**: Optimizes network calls and database interactions.
- **Unit Testing (XCTest)**: Ensures the reliability of core functionalities.

---

##  Future Enhancements

 Features planned for upcoming updates:

-  **Customization Options** – Allow users to personalize projects with tags, themes, and icons.
-  **Notes Feature** – Add a dedicated space for storing project-related ideas.
-  **UI/UX Enhancements** – Improve animations, transitions, and dark mode support.
-  **User Interaction Improvements** – Implement push notifications and in-app settings.
-  **Project Analytics** – Show detailed statistics on task completion and productivity.
-  **Onboarding Flow** – Enhance the first-time user experience with an interactive walkthrough.

---

##  Setup & Installation

 Clone the repository:

```sh
git clone https://github.com/yourusername/project-management-app.git
```

---

## Additional Thoughts

While the market is saturated with project management apps, this project remains a personal milestone. Despite being a work in progress with fewer features than some competitors, it was my first large-scale solo project on iOS. Throughout this journey, I gained invaluable technical skills and a deeper understanding of project timelines, setbacks, and milestones. More importantly, I learned firsthand what to expect in a professional setting, which will undoubtedly influence and enhance my approach to future projects.
