//
//  TestView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 11/19/21.
//

import SwiftUI

struct TestView: View {
	@State private var isShowingView = false
    var body: some View {
		VStack {
			Toggle(isOn: $isShowingView) {
				Text("Removed from Vehicle")
					.foregroundColor(.purple)
			}
			.padding()

			if isShowingView {
				VStack {
					Text("Date")
					Text("Milage")
				}

			}
		}
		.animation(.linear(duration: 0.3), value: isShowingView)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
