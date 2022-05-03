//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@ObservedObject var currentTire: TireEntity

	@State private var showEditingSheet = false
	@State private var tireStatus: TyreModel.TireStatus = .inStorage


	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				Text(currentTire.name ?? "")
					.font(Font.title2.bold())
					.minimumScaleFactor(0.5)
					.lineLimit(2)
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
			}

			Divider()

			HStack(alignment: .firstTextBaseline) {
				Text("Installed")
					.font(.title3.bold())
			}
			HStack {
				Text("Date:")
				Text(currentTire.installDate ?? Date(), style: .date)
			}

			HStack {
				Text("Mileage:")
				Text(currentTire.installMiles.rounded(), format: .number)
			}

			Text(currentTire.isInStorage ? "Removed" : "On Vehicle")
				.font(.title3.bold())
				.padding(.top)

			Group {
				HStack {
					Text("Date:")
					Text(currentTire.removalDate ?? Date(), style: .date)
				}
				HStack {
					Text("Mileage:")
						.padding(.trailing)
					Text(currentTire.removalMiles.rounded(), format: .number)
						.padding(.leading, -10)
				}

				HStack {
					Text("Total \(currentTire.name ?? "") Myles").bold()
						.fixedSize(horizontal: false, vertical: true)
						.lineLimit(2)
						.minimumScaleFactor(0.7)
					Spacer()

					Button {
						showEditingSheet.toggle()
					} label: {
						Text(currentTire.totalTyreMyles, format: .number)
							.foregroundColor(.primary)
							.padding([.top, .bottom])
					}

				}.font(.title2)
			}.opacity(currentTire.isInStorage ? 1.0 : 0.25)
		}.font(.footnote.monospaced())

			.sheet(isPresented: $showEditingSheet) {
				// on dismiss
			} content: {
				EditTireView(currentTire: currentTire, previousInstallMileage: currentTire.installMiles, previousRemovalMilage: currentTire.removalMiles)
			}

			.background {
				if currentTire.isInStorage {
					Text("In Storage")
						.font(.largeTitle.bold())
						.opacity(0.08)
				}
			}
	}

}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView(currentTire: entity.tires.first)
//			.preferredColorScheme(.dark)
//    }
//}
