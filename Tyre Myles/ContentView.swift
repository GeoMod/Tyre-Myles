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

	@State private var isEditingDetails = false

	@State private var selectedTireSeason: TireType = .allSeason


	var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				if dataModel.savedTires.count == 0 {
					EmptyTireView
				}
				List {
					ForEach(dataModel.savedTires, id: \.id) { tire in
						VStack {
							HStack {
								Text(tire.name!)
									.font(Font.system(size: 26).bold())
								Spacer()
								Button {
									isEditingDetails.toggle()
								} label: {
									Image(systemName: "square.and.pencil")

										.font(.headline)
								}.buttonStyle(.bordered)

							}
							DateMilageView(currentTire: tire)
						}
					}.onDelete { index in
						dataModel.deleteTire(at: index)
					}
				}

			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					EditButton()
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink {
						AddTireView()
					} label: {
						Image(systemName: "plus.circle")
							.font(.title2.bold())
					}
				}
			}
			.navigationTitle("My Tyre Myles")
		}

	}

	private var EmptyTireView: some View {
		VStack {
			HStack(spacing: 40) {
				Image(systemName: "text.below.photo.fill")
					.font(Font.system(size: 80))
					.frame(height: 100)
					.shadow(color: .clear, radius: 1, x: 0, y: 0)
				Image(systemName: "text.below.photo.fill")
					.font(Font.system(size: 80))
					.frame(height: 100)
					.shadow(color: .clear, radius: 1, x: 0, y: 0)
				Image(systemName: "text.below.photo.fill")
					.font(Font.system(size: 80))
					.frame(height: 100)
					.shadow(color: .clear, radius: 1, x: 0, y: 0)
			}
			Text("No Tires Added")
				.font(.title)
		}
	}

//	private func selected(tire: TireEntity) {
//		selectedTire = tire
//	}


//	private var Title: some View {
//		Text("My Tyre Myles")
//			.font(Font.system(size: 35, weight: .semibold))
//			.foregroundStyle(LinearGradient(gradient: cARGradientColors, startPoint: .leading, endPoint: .trailing))
//	}


//					Image("Summer")
//						.resizable()
//						.aspectRatio(contentMode: .fit)
//						.frame(width: 100, height: 100)
//						.background { colorScheme == .dark ? Color.black : Color.white }
//						.clipShape(Circle())

}


struct ContentView_Previews: PreviewProvider {
	static let model = DataModel(managedObjectContext: PersistenceController.shared.container.viewContext)

    static var previews: some View {
		ContentView()
			.environmentObject(model)
//		Image(systemName: "plus.circle")
//			.foregroundColor(.red)
//			.font(.title2.bold())

    }
}
