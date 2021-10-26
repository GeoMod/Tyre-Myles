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

	@State private var selectedTire: TireType = .winter
//	@State private var isAddingNewTire = false

	let winterBackground = "WinterBackground"
	let summerBackground = "Background"


	var body: some View {
		NavigationView {
			VStack {
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
									.foregroundColor(.primary)
							}
						}.shadow(color: .gray, radius: 5, x: 3, y: 0)
					}
				}
				Text(selectedTire.rawValue)
					.foregroundColor(selectedTire == .summer ? .orange : .secondary)
					.font(.title.bold())
					.padding()
				Text("Edit")
					.foregroundColor(.blue)
				DateMilageView()
				Spacer()
			}
			.navigationTitle("Tyre Myles")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					NavigationLink {
						NewTireView()
					} label: {
						Image(systemName: "chevron.forward")
							.foregroundColor(.secondary)
							.shadow(radius: 2)
							.font(.title2)
					}
				}
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
			.font(Font.system(size: 35, weight: .semibold))
			.foregroundStyle(LinearGradient(gradient: cARGradientColors, startPoint: .leading, endPoint: .trailing))
	}


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//			.preferredColorScheme(.dark)
		//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
