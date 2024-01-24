//
//  OnboardingView.swift
//  TaskManagmentApp
//
//  Created by Tekla on 1/23/24.
//

import SwiftUI

struct OnboardingView: View {
    //MARK: - Properties
    @State private var onboardingViewed = UserDefaults.standard.bool(forKey: "onboarding_viewed")
    @State private var pageIndex = 0
    
    private let pages: [PageModel] = PageModel.samplePage

    //MARK: - Body
    var body: some View {
            onboarding
    }
}

//MARK: - Content
extension OnboardingView {
    //Pages View
    private var onboarding: some View {
        TabView(selection: $pageIndex) {
            tabPages
        }
        //.animation(.easeInOut, value: pageIndex)
        //.tabViewStyle(.page)
        //.indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .background(Color.blue).ignoresSafeArea()
    }
    
    private var tabPages: some View {
        ForEach(pages) { page in
            VStack {
                PageView(page: page)
                Spacer()
                if page == pages.last {
                    getStartedButton
                } else {
                    nextButton
                }
                Spacer(minLength: 50)
            }
            .tag(page.tag)
        }
    }
    
    //Functions
    private func incrementPage() {
        pageIndex += 1
    }
    
    private func goToZero() {
        pageIndex = 0
    }
    
    private var nextButton: some View {
        //OnboardingButton(action: incrementPage, actionText: "Next")
        Button(action: {
            incrementPage()
        }) {
            Text("Next Button")
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
    
    private var getStartedButton: some View {
        Button(action: {
            UserDefaults.standard.set(true, forKey: "onboarding_viewed");                           print("Get Started tapped")
        }) {
            Text("Get Started")
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
}

//MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
