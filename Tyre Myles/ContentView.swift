//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

	let tireImages = ["Summer", "Winter"]
	enum TireType: String, CaseIterable, Identifiable {
		// Identifiable for use in ForEach
		var id: String { UUID().uuidString }

		case summer = "Summer"
		case winter = "Winter"
	}

	@State private var summerSelected = false
	@State private var selectedTire: TireType = .summer


	var body: some View {
		ZStack {
			Color("Background").ignoresSafeArea()
			VStack {
				Title
				Text("Select Season")
					.foregroundColor(.gray)
					.font(.title.bold())
					.padding()
				HStack(spacing: 30) {
					ForEach(TireType.allCases) { tire in
						Button {
							selectedTire(type: tire)
						} label: {
							VStack {
								Image(tire.rawValue)
									.resizable()
									.padding()
									.frame(width: 150, height: 150)
									.background { Color.white }
									.clipShape(RoundedRectangle(cornerRadius: 18))
								Text(tire.rawValue)
									.font(Font.system(size: 26))
									.foregroundColor(.white)
							}
						}.shadow(color: .gray, radius: 5, x: 3, y: 0)
					}
				}
				Text(selectedTire.rawValue)
					.foregroundColor(selectedTire == .summer ? .red : .white)
					.font(.title.bold())
					.padding()
				DateMilageView()
			}

		}
	}

	private func selectedTire(type: TireType) {
		switch type {
			case .summer:
				selectedTire = .summer
			case .winter:
				selectedTire = .winter
		}
	}

	private var Title: some View {
		Text("My Tyre Myles")
			.font(Font.system(size: 40, weight: .semibold, design: .rounded))
			.foregroundStyle(LinearGradient(gradient: cARGradientColors, startPoint: .leading, endPoint: .trailing))
	}


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
		//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
