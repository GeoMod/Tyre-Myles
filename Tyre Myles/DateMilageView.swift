//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {
	@ObservedObject var currentTire: TireEntity

	// Will need to be saved for both summer and winter values.
	@State private var totalMilage = "999"
//	@State private var installMilage = "0"
//	@State private var removalMilage = "0"


	var body: some View {
			VStack(alignment: .leading) {
				HStack(alignment: .firstTextBaseline) {
					Text("Intallation")
						.font(.title3.bold())
				}
				HStack {
					Text("Date:")
					Text(currentTire.installDate ?? Date(), style: .date)
				}

				HStack {
					Text("Milage:")
					Text(String(format: "%.0f", currentTire.installMiles))
				}

				Text("Removal")
					.font(.title3.bold())
					.padding([.top])
				HStack {
					Text("Date:")
					Text(currentTire.removalDate ?? Date(), style: .date)
				}
				HStack {
					Text("Milage:")
						.padding(.trailing)
					Text(String(format: "%.0f", currentTire.removalMiles))
						.padding(.leading, -10)
				}
				HStack {
					Text("Total Tyre Myles")
						.bold()

					Spacer()
					Text(totalMilage)
						.foregroundColor(.red)
						.bold()
				}.font(.title2)
			}.font(.footnote.monospaced())
			.onAppear {
				calculateTotalMilesFrom(installation: currentTire.installMiles, removal: currentTire.removalMiles)
			}


//		.sheet(isPresented: $isEditingDetails) {
//			print("editor was dismissed")
//		} content: {
//			EditTireView(installDate: $installDate, removalDate: $removalDate, installMilage: $installMilage, removalMilage: $removalMilage, totalMilage: $totalMilage)
//		}
	}


	@MainActor private func calculateTotalMilesFrom(installation: Double, removal: Double) {
		let total = removal - installation
		if total > 0 {
			totalMilage = String(Int(total))
		} else {
			totalMilage = "On Vehicle"
		}

	}

	

}

//struct DateMilageView_Previews: PreviewProvider {
//    static var previews: some View {
//		DateMilageView()
//			.preferredColorScheme(.dark)
//    }
//}
