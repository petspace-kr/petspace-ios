//
//  ViewExtensions.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/9/23.
//

import SwiftUI

struct Background: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var background: Material { colorScheme == .light ? .regularMaterial : .thickMaterial }
    
    func body(content: Content) -> some View {
        content
            .background(background)
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(.systemFill), radius: 5)
    }
}

extension View {
    func materialBackground() -> some View {
        self.modifier(Background())
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ applyModifier: Bool = true, @ViewBuilder content: (Self) -> Content) -> some View {
        if applyModifier {
            content(self)
        } else {
            self
        }
    }
    
    func horizontallyCentred() -> some View {
        HStack {
            Spacer(minLength: 0)
            self
            Spacer(minLength: 0)
        }
    }
    
    func bigButton() -> some View {
        self
            .font(.body.bold())
            .padding()
            .horizontallyCentred()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(15)
    }
    
    func bigButton(backgroundColor: Color) -> some View {
        self
            .font(.body.bold())
            .padding()
            .horizontallyCentred()
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(15)
    }
    
    func standardButtonText() -> some View {
        self
            .horizontallyCentred()
            .frame(height: 36)
    }
    
    func standardButtonText(foregroundColor: Color) -> some View {
        self
            .horizontallyCentred()
            .frame(height: 36)
            .foregroundColor(foregroundColor)
    }
    
    func standardButton() -> some View {
        self
            .buttonBorderShape(.roundedRectangle(radius: 20))
            .buttonStyle(.borderedProminent)
            .tint(Color.accentColor)
    }
    
    func standardButton(backgroundColor: Color) -> some View {
        self
            .buttonBorderShape(.roundedRectangle(radius: 20))
            .buttonStyle(.borderedProminent)
            .tint(backgroundColor)
    }
    
    // Corner Radius
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
