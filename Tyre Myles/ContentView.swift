//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var dataModel: DataModel

	let tireImages = ["Summer", "Winter"]

	@State private var selectedTire: TireType = .winter


	var body: some View {
		NavigationView {
			VStack {

				ScrollView(.horizontal, showsIndicators: true) {

					if dataModel.savedTires.count == 0 {
						// Display empty scroll view
						Text("No tires added")
					}

					HStack(spacing: 40) {
						ForEach(dataModel.savedTires, id: \.id) { tire in
							Button {
								selectedTireInstallation(date: tire.installDate!)
							} label: {
								VStack {
									Image("Summer")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.frame(width: 100, height: 100)
										.background { colorScheme == .dark ? Color.black : Color.white }
										.clipShape(Circle())
									Text(tire.name!)
										.font(Font.system(size: 26))
										.foregroundColor(.primary)

								}
							}
						}
					}

				}.shadow(color: .gray, radius: 5, x: 1, y: 0)

				Text(selectedTire.rawValue)
					.foregroundColor(selectedTire == .summer ? .orange : .secondary)
					.font(.title.bold())
					.padding()
//				DateMilageView(currentTire: dataModel.savedTires)
			}
			.navigationTitle("Tyre Myles")
//			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					NavigationLink {
						AddTireView()
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

	private func selectedTireInstallation(date: Date) {

//		get the tire from the matching installation date


//		switch type {
//			case .summer:
//				selectedTire = .summer
//			case .winter:
//				selectedTire = .winter
//			case .rim1:
//				selectedTire = .winter
//			case .rim2:
//				selectedTire = .winter
//		}
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
