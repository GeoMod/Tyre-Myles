//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI


struct DateMilageView: View {

	@AppStorage("installDistance") var installMilage = "23000"
	@AppStorage("removalDistance") var removalMilage = "320987"

	@State private var isEditingDetails = false

	// Will need to be saved for both summer and winter values.
	@State private var totalMilage = "0"

	@State private var installDate = Date()
	@State private var removalDate = Date()


	var body: some View {
		VStack {

			VStack(alignment: .leading) {
				HStack(alignment: .firstTextBaseline) {
					Text("Intallation")
						.font(.title2.bold())
						.padding(.top)
						Spacer()

					Button {
						isEditingDetails.toggle()
					} label: {
						Image(systemName: "square.and.pencil")
					}
				}
				HStack {
					Text("Date:")
					Text(installDate, style: .date)
						.padding(.leading, 30)
				}

				HStack {
					Text("Milage:")
						.padding(.trailing)
					Text(installMilage)
						.padding(.leading, -10)
				}

				Text("Removal")
					.font(.title2.bold())
					.padding([.top])
				HStack {
					Text("Date:")
					Text(removalDate, style: .date)
						.padding(.leading, 30)
				}
				HStack {
					Text("Milage:")
						.padding(.trailing)
					Text(removalMilage)
						.padding(.leading, -10)
				}
			}

			Text("Total Tyre Myles")
				.bold()
				.padding([.top, .bottom], 5)
			Text("\(totalMilage)")
				.font(.largeTitle)
				.bold()

		}
		.padding([.leading, .trailing])
		.font(.title3.monospaced())

		.sheet(isPresented: $isEditingDetails) {
//			print("editor was dismissed")
		} content: {
			TireDataEntryView(installDate: $installDate, removalDate: $removalDate, installMilage: $installMilage, removalMilage: $removalMilage, totalMilage: $totalMilage)
		}
//
//		.sheet(isPresented: $isPresendingMilageSheet) {
//			// do nothing if dismissed manually
//		} content: {
//			MilageSheetView(installMilage: $installMilage, removalMilage: $removalMilage, totalMilage: $totalMilage)
//		}
	}

	

}

struct DateMilageView_Previews: PreviewProvider {

    static var previews: some View {
        DateMilageView()
//			.preferredColorScheme(.dark)
    }
}
